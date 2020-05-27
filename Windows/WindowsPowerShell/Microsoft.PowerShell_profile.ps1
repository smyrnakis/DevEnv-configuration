# function prompt {"$(Get-Date)> "}
<# function prompt {
    $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
      else { '' }) + 'PS ' + $(Get-Location) +
        $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
} #>
<# function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
    elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    else { '' }
  ) + 'PS ' + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
} #>
<# function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
    elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    else { '' }
  ) + 'PS ' + "[$(Get-Date)] " + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
} #>

<# function prompt {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  $(if (Test-Path variable:/PSDebugContext) { '[DBG] ' }
    elseif($principal.IsInRole($adminRole)) { '[ADMIN] ' }
    else { '' }
  ) + "[$(Get-Date)] " + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
} #>


# Importing modules
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
Import-Module posh-git
Import-Module oh-my-posh

# Settings for oh-my-posh
Set-Theme Paradox

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Aliases
# cd to C:\Git directory
function Cd-Git {
  Set-Location -Path C:\Git
}
Set-Alias cdgit Cd-Git

# equivalent to unix 'ls -la' (list files including hidden ones)
function ls-la {
  param([string]$_)
  Get-ChildItem -Force $_
}
Set-Alias lsla ls-la

# equivalent to unix 'touch'
function New-Item-File {
  param([string]$_)
  # New-Item -Itemtype File -Path $_ -Force
  echo $null >> $_
}
Set-Alias touch New-Item-File