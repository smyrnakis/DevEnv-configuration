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

  # chcp 65001
  # echo $null >> $_

  Out-File -FilePath $_ -Encoding utf8 -Force -NoNewline -NoClobber
}
Set-Alias touch New-Item-File

# get size of a directory
function Size-Of {
  #param([parameter(Mandatory=$true)][string]$_)
  param($_)

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
Set-Alias sizeof Size-Of

# get account's creation date
function Get-WhenCreated {
	param($_)

	(Get-ADUser -Identity "$_" -Properties whenCreated).whenCreated
}
Set-Alias whenCreated Get-WhenCreated