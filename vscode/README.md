# Visual Studio Code 配置

这里集中维护本仓库使用的 VS Code 用户设置和快捷键：

- `settings.json`：VSCodeVim 设置、Vim 模式映射、leader 快捷键及主题。
- `keybindings.json`：IDEA Windows Vim keymap 中可迁移到 VS Code 的键盘映射。
- `install.ps1`：将配置合并到当前 Windows 用户的 VS Code 配置目录，并在覆盖前创建备份。

## 前置要求

安装 **Vim（VSCodeVim）** 扩展，扩展 ID 为 `vscodevim.vim`。可以在 VS Code 扩展面板搜索 `Vim` 安装。

也可在终端运行：

```powershell
code --install-extension vscodevim.vim
```

部分动作会依赖语言扩展、测试扩展或 Git 仓库。例如跳转到实现、类型层级及测试视图可能因当前语言和扩展而不可用；IDEA 专属动作没有强行伪装成 VS Code 动作。

## 在 Windows 上应用

克隆本仓库后，在 PowerShell 中运行：

```powershell
cd "$env:LOCALAPPDATA\nvim\vscode"
.\install.ps1
```

脚本默认应用到：

```text
$env:APPDATA\Code\User
```

脚本会保留目标机器原有的其他设置和快捷键：

- `settings.json` 只更新本目录声明的设置项，未声明的设置保留。
- `keybindings.json` 保留其他快捷键；若同一个 `key` 和 `when` 已存在，则用仓库版本替换。
- 脚本接受 VS Code 常见的 JSONC 注释和尾逗号格式。
- 修改前会为原文件创建带时间戳的 `.bak` 备份（如果原文件存在）。

### VS Code Insiders 或自定义配置目录

可通过参数指定目标用户目录，例如：

```powershell
.\install.ps1 -UserDataDir "$env:APPDATA\Code - Insiders\User"
```

也可以传入 VS Code 使用的其他 `User` 配置目录。完成后重载 VS Code 窗口。

## 手动应用

如果不想运行脚本，可将 `settings.json` 中的设置合并到 VS Code 的 `settings.json`，并将 `keybindings.json` 中的条目合并到 VS Code 的 `keybindings.json`。不要直接覆盖目标电脑的整个用户配置，以免丢失其他设置。

## 快捷键概览

- 插入模式输入 `jk` 或 `kj`：退出到 Normal 模式。
- 空格作为 Vim leader；例如 `<Space> f f` 打开文件，`<Space> f a` 打开命令面板，`<Space> g c` 提交 Git。
- Normal 模式 `Ctrl+H/J/K/L`：方向移动；在列表/资源管理器焦点中也用于树导航。
- `Alt+H/L` 或 `Alt+Left/Right`：切换编辑器标签。
- `Alt+Shift+J/K` 或 `Alt+Shift+Up/Down`：移动当前行。
- `Ctrl+Alt+J/K`：添加下一个/上一个匹配项光标。
- `F3` / `Shift+F3`：查找下一个/上一个匹配项。
- `Alt+I`：Quick Fix；`Alt+O`：重构代码操作。

快捷键以当前仓库中的 JSON 文件为准；README 只提供常用操作速查。
