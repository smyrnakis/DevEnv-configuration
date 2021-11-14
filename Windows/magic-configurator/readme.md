# Magic Configurator

## Intro

This script is handling automatically *most* of the steps described in [Windows Configuration](https://github.com/smyrnakis/DevEnv-configuration/tree/master/Windows) chapter.

## Execution

The script needs to run with **elevated** privileges. It is recommended that you copy it in the `C:\` drive and execute it from there.

``` ps1
powershell -executionpolicy bypass -nologo -File C:\magic-configurator.ps1
```

## Auto installed packages

After installing `choco`, the following packages are installed:

- standard software
    - googlechrome
    - firefox
    - 7zip.install
    - vlc
    - dropbox
    - boxsync
    - authy-desktop
    - teamviewer
    - joplin
    - openvpn-connect
    - keepassxc
    - lightshot
    - onlyoffice
    - **spotify**
- development software
    - notepadplusplus.install
    - cmder
    - ConEmu
    - microsoft-windows-terminal
    - vim
    - git.install
    - vscode.install
    - python --pre
    - mobaxterm
    - winscp.install
    - arduino
    - powertoys

## PowerShell & terminal settings

- Execution policy: bypass
- Install modules
    - PowerShellGet
    - posh-git
    - oh-my-posh
    - Terminal-Icons

- Download & install fonts
    - MesloLGS NF

## Windows settings

- create folders
    - `C:\Git`
    - `C:\Git\personal`
    - `C:\Git\professional`
- add *GodMode* shortcut in `Desktop`
- configure system clock to 24h
- enable hibernation
- restore open apps on Windows logon
- enable service: 'OpenSSH Authentication Agent'

## Windows Explorer settings

- open Files Explorer to `This PC`
- multi-monitor: taskbar icon where window is located
- show file extensions
- show checkboxes
- launch each folder in separate process
- restore open folders at logon
- show full path in title bar

## Extra

- add Git aliases

## Known issues

- `choco` installations
    - `spotify` package failed to installed and timed out

## Under development

- create & add SSH keys for Git