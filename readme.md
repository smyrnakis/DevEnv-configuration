# General info
## Windows
https://github.com/JanDeDobbeleer/oh-my-posh

## Mac
https://github.com/ohmyzsh/ohmyzsh
https://medium.com/swlh/power-up-your-terminal-using-oh-my-zsh-iterm2-c5a03f73a9fb
https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c

<br>

# Terminal configuration
## > Windows
### Chocolatey
``` ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

### ConEmu & Windows Terminal
``` ps1
choco install ConEmu
choco install microsoft-windows-terminal
```

### Configure Powershell
``` ps1
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```
``` ps1
Set-Prompt
Set-Theme Paradox
```

#### Configure Powershell PROFILE
``` ps1
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
```
Add the bellow in `$PROFILE`:
``` ps1
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
```

#### Configure ConEmu
Settings --> Fonts : Meslo

<br>

## > Mac
### iTerm2


https://github.com/zsh-users/zsh-autosuggestions

<br>

# VIM
## Installation
### > Windows


### > Mac

<br>

# GIT
## Installation
### > Windows

### > Mac


## Aliaces
``` git
alias.st status
alias.lga log --all --decorate --oneline --graph
alias.lg log --decorate --oneline --graph
alias.lgg log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches
alias.pom push origin master
alias.poh push origin $(git rev-parse --abbrev-ref HEAD)
alias.amn commit --amend --no-edit
alias.am commit --amend
alias.ca commit -am
alias.cm commit -m
```

<br>

# MS Visual Studio code
## Installation
### > Windows

### > Mac

## Settings sync
1) Install the [Settings sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) plugin.
2) Use the gist ID `508d76ad7d54c9a1b6cbc3c1c71e7343`
https://gist.github.com/smyrnakis/508d76ad7d54c9a1b6cbc3c1c71e7343
3) Time and restarts of VS Code will be needed!
