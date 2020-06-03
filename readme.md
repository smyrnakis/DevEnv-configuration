# General info

Based on work and code from various projects:

* https://github.com/JanDeDobbeleer/oh-my-posh
* https://gist.github.com/JanDeDobbeleer/71c9f1361a562f337b855b75d7bbfd28
* https://github.com/ryanoasis/nerd-fonts
* https://github.com/ohmyzsh/ohmyzsh
* https://medium.com/swlh/power-up-your-terminal-using-oh-my-zsh-iterm2-c5a03f73a9fb
* https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c

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

Installation of [posh-git](https://dahlbyk.github.io/posh-git/) and [oh-my-posh](https://pecigonzalo.github.io/Oh-My-Posh/).
``` ps1
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```
``` ps1
Set-Prompt
Set-Theme Paradox
```

To see the theme settings, use:
``` ps1
$ThemeSettings
```

To see colors and theme colors, use:
``` ps1
Show-ThemeColors
Show-Colors
```

To set the branch symbol, use:
``` ps1
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xE0A0)
```

Hide your `username@domain` when not in a virtual machine for the Agnoster, Fish, Honukai, Paradox and Sorin themes:
``` ps1
$DefaultUser = 'username'
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

To reload Powershell profile, run:
``` ps1
. $PROFILE
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

``` ps1
choco install vim
```

### > Mac

## Cheatsheet

`w`: next word<br>
`b`: previous word<br>
`gg`: go to the top of the file<br>
`G`: go to the bottom of the file<br>
`:%d`: delete every line<br>
`=G`: fix indentation in all document (only if cursor is moved on top)<br>
`S`: start writing on a line at correct indentation<br>
`>` `<`: indent/unindent multiple lines (in visual line mode)<br>
`>>` `<<`: indent/unindent a line<br>
`:tabnew` creates a new tab<br>
`gt` go to next tab<br>
`gT` go to previous tab<br>
`:tabo` close all other tabs besides the active one<br><br>

`:setlocal spell` enable spell check
`:set nospell` disable spell check

* https://www.freecodecamp.org/news/7-vim-tips-that-changed-my-life/

## Plugins

* [vim-plug](https://github.com/junegunn/vim-plug) plugin manager
* [https://vimawesome.com/](https://vimawesome.com/) collection of Vim plugins
* [vim-fugitive](https://github.com/tpope/vim-fugitive) git plugin for Vim
* [auto-pairs](https://github.com/jiangmiao/auto-pairs) insert or delete brackets, parens, quotes in pair
* https://vimawesome.com/

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

<br>

# Notepad++

## Installation



<br>