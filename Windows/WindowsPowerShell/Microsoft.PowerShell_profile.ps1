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
if (Get-Module -ListAvailable -Name posh-git) {
	Import-Module posh-git
}
else {
	Install-Module posh-git -Scope CurrentUser -Force -Verbose
	Import-Module posh-git
}
if (Get-Module -ListAvailable -Name oh-my-posh) {
	Import-Module oh-my-posh
}
else {
	Install-Module oh-my-posh -Scope CurrentUser -Force -Verbose
	Import-Module oh-my-posh
}

# Settings for oh-my-posh
# Set-PoshPrompt -Theme Paradox
Set-PoshPrompt -Theme iterm2

# For the item icons in 'ls' command
Import-Module -Name Terminal-Icons

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Location to start up in
Set-Location C:\Git

# Aliases
# print all aliases
function print-aliases {
	Write-Host "`n`tadminps`t`t:`topen a new Admin PowerShell session
	`n`tadminterminal`t:`topen a new Admin Windows Terminal
	`n`tcdgit`t`t:`tcd C:\Git
	`n`tll`t`t:`tequivalent to ls -la
	`n`ttouch`t`t:`tequivalent to unix touch
	`n`tsizeof`t`t:`tprint size of directory`n"
}
Set-Alias aliases print-aliases

# open a new Admin PowerShell session
function ps-admin {
  Start-Process -Verb RunAs powershell.exe
}
Set-Alias adminps ps-admin

# open a new Admin Windows Terminal
function terminal-admin {
  powershell "Start-Process -Verb RunAs cmd.exe '/c start wt.exe'"
}
Set-Alias adminterminal terminal-admin

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
Set-Alias ll ls-la

# equivalent to unix 'touch'
function New-Item-File {
  param([string]$_)
  # New-Item -Itemtype File -Path $_ -Force

  # chcp 65001
  # echo $null >> $_

  Out-File -FilePath $_ -Encoding utf8 -Force -NoNewline -NoClobber
}
Set-Alias touch New-Item-File

# get size of a directory
function Size-Of {
  #param([parameter(Mandatory=$true)][string]$_)
  param($_)

  if (-not (Test-Path $_)) {
	Write-Error "path not found"
  }
  else {
	  $dirSize = (Get-ChildItem -Path $_ -Force -Recurse | Measure-Object -Sum Length | Select-Object Sum).Sum
	  switch ($dirSize) {
		{$dirSize -lt 1000} {
			Write-Host $dirSize B
			break
		}
		{$dirSize -lt 1048576} {
			Write-Host "$([math]::round($dirSize/1024,2)) KB"
			break
		}
		{$dirSize -lt 1073741824} {
			Write-Host "$([math]::round($dirSize/1024/1024,2)) MB"
			break
		}
		{$dirSize -lt 1099511627776} {
			Write-Host "$([math]::round($dirSize/1024/1024/1024,2)) GB"
			break
		}
		default {
			Write-Host "$([math]::round($dirSize/1024/1024/1024/1024,2)) TB"
			break
		}
	  }
  }
}
Set-Alias sizeof Size-Of