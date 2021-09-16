# Windows terminal configuration

Based on work and code from various projects:

* https://github.com/JanDeDobbeleer/oh-my-posh
* https://gist.github.com/JanDeDobbeleer/71c9f1361a562f337b855b75d7bbfd28
* https://dejanstojanovic.net/powershell/2021/june/customizing-powershell-with-oh-my-posh-v3/
* https://github.com/ohmyzsh/ohmyzsh
* https://medium.com/swlh/power-up-your-terminal-using-oh-my-zsh-iterm2-c5a03f73a9fb
* https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c

<br>

# choco

Install <a href="https://chocolatey.org/install" target="_blank">chocolatey</a> software manager.

In an *Administrator* PowerShell session type:

``` ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

<br>

# Terminal

## cmder

Install <a href="https://cmder.net/" target="_blank">cmder</a> using *choco*:

``` ps1
choco install cmder
```

### Keyboard shortcuts

#### Tab manipulation

`Win + Alt + p` : Preferences (Or right click on title bar)

`Ctrl + t` : New tab dialog (maybe you want to open cmd as admin?)

`Ctrl + w` : Close tab

`Shift + Alt + number` : Fast new tab:
1. CMD
2. PowerShell

`Alt + Enter` : Fullscreen

#### Shell

`Ctrl + Alt + u` : Traverse up in directory structure (lovely feature!)

`End, Home, Ctrl` : Traverse text as usual on Windows

`Ctrl + r` : History search

`Shift + mouse` : Select and copy text from buffer

`Right click / Ctrl + Shift + v` : Paste text 

<br>

## ConEmu & Windows Terminal

``` ps1
choco install ConEmu
choco install microsoft-windows-terminal
```

<br>

### Fonts

Download and install **Meslo** font <a href="https://github.com/romkatv/powerlevel10k/blob/master/font.md" target="_blank">here</a>.

*(alternative: <a href="https://github.com/ryanoasis/nerd-fonts" target="_blank">https://github.com/ryanoasis/nerd-fonts</a>)*

### Configure Powershell

Check if the `$profile` exist.

``` ps1
Test-Path $profile
```

If not (`False`), create it using the command:

``` ps1
New-Item -path $profile -type file –force
```

<br>

> Before moving forward you might need to allow the execution of PowerShell scripts.
> 
> To do so, execute `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`
> 
> It is recommended to restore the ExecutionPolicy in `Restricted` after you finish installing the tools!
> 
> More info <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1" target="_blank">about_Execution_Policies</a>

<br>

Installation of <a href="https://dahlbyk.github.io/posh-git/" target="_blank">posh-git</a> and <a href="https://pecigonzalo.github.io/Oh-My-Posh/" target="_blank">oh-my-posh</a>.

``` ps1
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```

``` ps1
Set-PoshPrompt
Set-PoshPrompt -Theme iterm2
```

To see the available list of themes, type:

``` ps1
Get-PoshThemes
```

To add icons next to items in `ls` command execute the following in an **elevated** prompt:

``` ps1
Install-Module -Name Terminal-Icons -Repository PSGallery  
```

<br>

Edit the PowerShell profile (usually in `~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`) and add the following:

<a href="https://github.com/smyrnakis/DevEnv-configuration/blob/master/Windows/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" target="_blank">Microsoft.PowerShell_profile.ps1</a>

Reload the `$profile` using the command:

``` ps1
. $profile
```

<!-- To set the branch symbol, use:
``` ps1
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xE0A0)
``` -->

<!-- Hide your `username@domain` when not in a virtual machine for the Agnoster, Fish, Honukai, Paradox and Sorin themes:
``` ps1
$DefaultUser = 'username'
``` -->

#### Configure Font

In **Windows Terminal**, go to *Settings* and click on *Windows PowerShell* under *Profiles*.

On *Font face* select the `Meslo` font. For *Font size* select `9`.

![powershell-font](pics/ps-font.png)

<br>

In **PowerShell** go to *Properties* --> *Font*.

Select the `Menslo` and click on **OK**.

<br>

# VIM

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install vim
```

## Cheatsheet

`w`: next word<br>
`b`: previous word<br>
`gg`: go to the top of the file<br>
`V`: visual mode<br>
`G`: go to the bottom of the file<br>
`ggVG`: select all<br>
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

In an **elevated** prompt, execute:

``` ps1
choco install git.install
```

## Configure user

``` ps1
git config --global user.name "<YOUR-NAME>"
git config --global user.email "<YOUR-EMAIL>"
```

## Aliases
``` ps1
git config --global alias.st 'status'
git config --global alias.lga 'log --all --decorate --oneline --graph'
git config --global alias.lg 'log --decorate --oneline --graph'
git config --global alias.lgg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"
git config --global alias.pom 'push origin master'
git config --global alias.poh 'push origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.amn 'commit --amend --no-edit'
git config --global alias.am 'commit --amend'
git config --global alias.ca 'commit -am'
git config --global alias.cm 'commit -m'
```

<br>

# MS Visual Studio code

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install vscode.install
```

<!-- ## Settings sync

1) Install the [Settings sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) plugin.
2) Use the gist ID `508d76ad7d54c9a1b6cbc3c1c71e7343`
https://gist.github.com/smyrnakis/508d76ad7d54c9a1b6cbc3c1c71e7343
3) Configure `syncLocalSettings.json` file to use same `keybindings.json` across all operating systems:

``` json
"universalKeybindings": true,
```

Location of `syncLocalSettings.json`:

* Windows: `%APPDATA%\Code\User\`
* macOS: `$HOME/Library/Application Support/Code/User/`
* Linux: `$HOME/.config/Code/User/`

Manual upload/download of settings:

* `Shift + Alt + U` : upload settings
* `Shift + Alt + D` : download settings

*Restarts of VS Code will be needed for the initial synchronisation!* -->

## List of custom shortcuts

* `Ctrl + Alt + t` : toggle panel
* `Ctrl + Alt + n` : new terminal in current script's location
* `Ctrl + Alt + c` : change terminal's directory to current script's location

<br>

# Notepad++

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install notepadplusplus.install
```

<br>

# Python

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install python --pre
```

<br>

# MobaXterm

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install mobaxterm
```

<br>

# WinSCP

## Installation

In an **elevated** prompt, execute:

``` ps1
choco install winscp.install
```

<br>
