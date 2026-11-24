[CmdletBinding()]
param(
    [string]$UserDataDir = (Join-Path $env:APPDATA 'Code\User')
)

$ErrorActionPreference = 'Stop'

function ConvertFrom-Jsonc {
    param([Parameter(Mandatory = $true)][string]$Content)

    $withoutComments = New-Object System.Text.StringBuilder
    $inString = $false
    $escaped = $false
    $lineComment = $false
    $blockComment = $false

    for ($index = 0; $index -lt $Content.Length; $index++) {
        $character = $Content[$index]
        $next = if ($index + 1 -lt $Content.Length) { $Content[$index + 1] } else { [char]0 }

        if ($lineComment) {
            if ($character -eq "`n" -or $character -eq "`r") {
                $lineComment = $false
                [void]$withoutComments.Append($character)
            }
            continue
        }

        if ($blockComment) {
            if ($character -eq '*' -and $next -eq '/') {
                $blockComment = $false
                $index++
            } elseif ($character -eq "`n" -or $character -eq "`r") {
                [void]$withoutComments.Append($character)
            }
            continue
        }

        if ($inString) {
            [void]$withoutComments.Append($character)
            if ($escaped) {
                $escaped = $false
            } elseif ($character -eq '\') {
                $escaped = $true
            } elseif ($character -eq '"') {
                $inString = $false
            }
            continue
        }

        if ($character -eq '"') {
            $inString = $true
            [void]$withoutComments.Append($character)
        } elseif ($character -eq '/' -and $next -eq '/') {
            $lineComment = $true
            $index++
        } elseif ($character -eq '/' -and $next -eq '*') {
            $blockComment = $true
            $index++
        } else {
            [void]$withoutComments.Append($character)
        }
    }

    $commentFree = $withoutComments.ToString()
    $withoutTrailingCommas = New-Object System.Text.StringBuilder
    $inString = $false
    $escaped = $false

    for ($index = 0; $index -lt $commentFree.Length; $index++) {
        $character = $commentFree[$index]
        if ($inString) {
            [void]$withoutTrailingCommas.Append($character)
            if ($escaped) {
                $escaped = $false
            } elseif ($character -eq '\') {
                $escaped = $true
            } elseif ($character -eq '"') {
                $inString = $false
            }
            continue
        }

        if ($character -eq '"') {
            $inString = $true
            [void]$withoutTrailingCommas.Append($character)
        } elseif ($character -eq ',') {
            $lookahead = $index + 1
            while ($lookahead -lt $commentFree.Length -and [char]::IsWhiteSpace($commentFree[$lookahead])) {
                $lookahead++
            }
            if ($lookahead -ge $commentFree.Length -or ($commentFree[$lookahead] -ne '}' -and $commentFree[$lookahead] -ne ']')) {
                [void]$withoutTrailingCommas.Append($character)
            }
        } else {
            [void]$withoutTrailingCommas.Append($character)
        }
    }

    return ConvertFrom-Json -InputObject $withoutTrailingCommas.ToString()
}

$settingsSource = Join-Path $PSScriptRoot 'settings.json'
$keybindingsSource = Join-Path $PSScriptRoot 'keybindings.json'

if (-not (Test-Path -LiteralPath $settingsSource)) {
    throw "Missing settings file: $settingsSource"
}
if (-not (Test-Path -LiteralPath $keybindingsSource)) {
    throw "Missing keybindings file: $keybindingsSource"
}

New-Item -ItemType Directory -Path $UserDataDir -Force | Out-Null

$settingsTarget = Join-Path $UserDataDir 'settings.json'
$keybindingsTarget = Join-Path $UserDataDir 'keybindings.json'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

if (Test-Path -LiteralPath $settingsTarget) {
    Copy-Item -LiteralPath $settingsTarget -Destination "$settingsTarget.$stamp.bak"
}
if (Test-Path -LiteralPath $keybindingsTarget) {
    Copy-Item -LiteralPath $keybindingsTarget -Destination "$keybindingsTarget.$stamp.bak"
}

$currentSettings = if (Test-Path -LiteralPath $settingsTarget) {
    ConvertFrom-Jsonc -Content (Get-Content -LiteralPath $settingsTarget -Raw)
} else {
    [pscustomobject]@{}
}
$managedSettings = ConvertFrom-Jsonc -Content (Get-Content -LiteralPath $settingsSource -Raw)

foreach ($property in $managedSettings.PSObject.Properties) {
    $currentSettings | Add-Member -MemberType NoteProperty -Name $property.Name -Value $property.Value -Force
}

$existingBindings = @()
if (Test-Path -LiteralPath $keybindingsTarget) {
    $parsedBindings = ConvertFrom-Jsonc -Content (Get-Content -LiteralPath $keybindingsTarget -Raw)
    if ($null -ne $parsedBindings) {
        $existingBindings = @($parsedBindings)
    }
}
$managedBindings = @(ConvertFrom-Jsonc -Content (Get-Content -LiteralPath $keybindingsSource -Raw))
$mergedBindings = New-Object 'System.Collections.Generic.List[object]'

foreach ($binding in $existingBindings) {
    if ($null -ne $binding) {
        $mergedBindings.Add($binding)
    }
}

foreach ($binding in $managedBindings) {
    $managedKey = [string]$binding.key
    $managedWhen = if ($null -eq $binding.when) { '' } else { [string]$binding.when }

    for ($index = $mergedBindings.Count - 1; $index -ge 0; $index--) {
        $existing = $mergedBindings[$index]
        $existingWhen = if ($null -eq $existing.when) { '' } else { [string]$existing.when }
        if ([string]$existing.key -eq $managedKey -and $existingWhen -eq $managedWhen) {
            $mergedBindings.RemoveAt($index)
        }
    }

    $mergedBindings.Add($binding)
}

$settingsJson = $currentSettings | ConvertTo-Json -Depth 100
$keybindingsJson = ConvertTo-Json -InputObject @($mergedBindings.ToArray()) -Depth 100
Set-Content -LiteralPath $settingsTarget -Value $settingsJson -Encoding UTF8
Set-Content -LiteralPath $keybindingsTarget -Value $keybindingsJson -Encoding UTF8

Write-Host "VS Code configuration installed to: $UserDataDir"
Write-Host "Existing settings were backed up with suffix .$stamp.bak (when present)."
Write-Host 'Restart or reload VS Code to apply the configuration.'
