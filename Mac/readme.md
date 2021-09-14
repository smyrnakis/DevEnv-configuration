# General info

Based on work and code from various projects:

* https://github.com/JanDeDobbeleer/oh-my-posh
* https://gist.github.com/JanDeDobbeleer/71c9f1361a562f337b855b75d7bbfd28
* https://github.com/ohmyzsh/ohmyzsh
* https://medium.com/swlh/power-up-your-terminal-using-oh-my-zsh-iterm2-c5a03f73a9fb
* https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c

<br>

# Fonts

https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf


# Terminal configuration

### iTerm2

Config file location: `~/Library/Preferences/com.googlecode.iterm2.plist`


https://github.com/zsh-users/zsh-autosuggestions

<br>

# VIM

### > Mac

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


## Aliases
``` git
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


## Settings sync

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

* `Shift + Alt + U`: upload settings
* `Shift + Alt + D`: download settings

*Restarts of VS Code will be needed for the initial synchronisation!*

## List of custom shortcuts

* `Ctrl + Alt + t`: toggle panel
* `Ctrl + Alt + n`: new terminal in current script's location
* `Ctrl + Alt + c`: change terminal's directory to current script's location

<br>
