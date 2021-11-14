param(
	[switch]$showDebugs = $false,
	[switch]$showErrors = $false
)


function Set-RegistryValue {
	param(
		[parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]$key,
		[parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]$value,
		[parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]$data,
		[parameter(Mandatory=$true)]
		[ValidateSet('String','ExpandString','DWORD')]
		[ValidateNotNullOrEmpty()]$type
	)

	try {
		New-ItemProperty -Path "$key" -Name "$value" -Value $data.ToString() -PropertyType "$type" -Force | Out-Null
	}
	catch {
		if ($showErrors) {
			Write-Host $_.Exception
			Write-Host $_.Exception.Message
			Write-Host $_.Exception.InnerExceptionMessage
			Write-Host $_.Exception.ItemName
		}
		return $false
	}
	return $true
}


# check if running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Host "`n[ERROR] Please run the script with elevated privileges. Exiting ..."
	Exit -1
}

$ErrorActionPreference = 'SilentlyContinue'


# registry paths
$key_SessionManagerConfiguration = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Configuration Manager'
$key_ControlPower = 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'
$key_FlyoutMenuSettings = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings'
$key_Winlogon = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$key_ControlPanelInternational = 'HKCU:\Control Panel\International'
$key_CurrentVersionExplorer = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
$key_ExplorerAdvanced = "$key_CurrentVersionExplorer\Advanced"
$key_CabinetState = "$key_CurrentVersionExplorer\CabinetState"


# configuring PowerShell
if ($showDebugs) { Write-Host "`n[INFO] configuring PowerShell ... " }

Set-ExecutionPolicy Unrestricted -Force

Import-Module PowerShellGet -Scope AllUsers -Force

Install-Module posh-git -Scope AllUsers -Force
Install-Module oh-my-posh -Scope AllUsers -Force

Set-PoshPrompt
Set-PoshPrompt -Theme iterm2

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope AllUsers -Force


# creating Git folders
if ($showDebugs) { Write-Host "`n[INFO] creating Git folders ... " }
$dir_git = 'C:\Git'
$dir_gitPersonal = "$dir_git\personal"
$dir_gitProfessional = "$dir_git\professional"

if (-Not (Test-Path "$dir_git")) { New-Item -ItemType Directory -Force -Path "$dir_git" | Out-Null }
if (-Not (Test-Path "$dir_gitPersonal")) { New-Item -ItemType Directory -Force -Path "$dir_gitPersonal" | Out-Null }
if (-Not (Test-Path "$dir_gitProfessional")) { New-Item -ItemType Directory -Force -Path "$dir_gitProfessional" | Out-Null }


# download fonts
if ($showDebugs) { Write-Host "`n[INFO] downloading fonts ... " }
$source1 = 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
$source2 = 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
$source3 = 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
$source4 = 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'

$dir_tempFonts = "$env:temp\downloaded-fonts"
New-Item -ItemType Directory -Force -Path "$dir_tempFonts" | Out-Null

Invoke-WebRequest -Uri "$source1" -OutFile "$dir_tempFonts\MesloLGS NF Regular.ttf"
Invoke-WebRequest -Uri "$source2" -OutFile "$dir_tempFonts\MesloLGS NF Bold.ttf"
Invoke-WebRequest -Uri "$source3" -OutFile "$dir_tempFonts\MesloLGS NF Italic.ttf"
Invoke-WebRequest -Uri "$source4" -OutFile "$dir_tempFonts\MesloLGS NF Bold Italic.ttf"


# install fonts
# TO FIX: CHECK IF FONT EXIST BEFORE TRYING INSTALLATION
if ($showDebugs) { Write-Host "`n[INFO] installing fonts ... " }

$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder  = "$env:temp\temp-fonts"

New-Item $TempFolder -Type Directory -Force | Out-Null

Get-ChildItem -Path "$dir_tempFonts\*" -Include '*.ttf','*.ttc','*.otf' -Recurse | ForEach-Object {
    if (-Not (Test-Path "C:\Windows\Fonts\$($_.Name)")) {

        $Font = "$TempFolder\$($_.Name)"
        
        # Copy font to local temporary folder
        Copy-Item $($_.FullName) -Destination $TempFolder
        
        # Install font
        $Destination.CopyHere($Font,0x10)

        # Delete temporary copy of font
        Remove-Item $Font -Force
    }
}


# add Godmode shortcut on Desktop
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
New-Item "$DesktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -Type Directory -Force | Out-Null


# enable registry periodic backups
# https://docs.microsoft.com/en-us/troubleshoot/windows-client/deployment/system-registry-no-backed-up-regback-folder
# if ($showDebugs) { Write-Host "`n[INFO] configuring periodic registry backups ... " -NoNewline }
# $tempOutcome1 = Set-RegistryValue -key $key_SessionManagerConfiguration -value 'EnablePeriodicBackup' -data 1 -type DWORD
# if ($tempOutcome1) {
	# if ($showDebugs) { Write-Host " DONE" }
# }
# else {
	# if ($showDebugs) { Write-Host " ERROR" }
# }


# set clock to 24h
if ($showDebugs) { Write-Host "`n[INFO] configuring system clock ... " -NoNewline }
# https://www.mytechyard.com/2011/01/change-computer-clock-format-by-changing-registry-value/
$tempOutcome1 = Set-RegistryValue -key $key_ControlPanelInternational -value 'sShortTime' -data 'HH:mm' -type ExpandString
$tempOutcome2 = Set-RegistryValue -key $key_ControlPanelInternational -value 'sTimeFormat' -data 'HH:mm:ss' -type ExpandString

if ($tempOutcome1 -and $tempOutcome2) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}


# configure Windows Explorer

# opens PC to This PC, not quick access
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: open to This PC ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'LaunchTo' -data 1 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced LaunchTo 1
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

#taskbar where window is open for multi-monitor
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: each Window to each taskbar ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'MMTaskbarMode' -data 2 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced MMTaskbarMode 2
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

# show files extensions
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: show file extensions ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'HideFileExt' -data 0 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced HideFileExt 0
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

# show checkbox
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: show checkboxes ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'AutoCheckSelect' -data 1 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced AutoCheckSelect 1
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

# launch each folder in separate process
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: separate processes ... " -NoNewline }
# https://www.tenforums.com/tutorials/125919-enable-disable-launch-folder-windows-separate-process-windows.html
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'SeparateProcess' -data 1 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced SeparateProcess 1
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

# restore previous folders windows at logon
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: restore folders at logon ... " -NoNewline }
# https://www.tenforums.com/tutorials/67701-turn-restore-previous-folder-windows-logon-windows-10-a.html
$tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'PersistBrowsers' -data 1 -type DWORD
# Set-ItemProperty $key_ExplorerAdvanced PersistBrowsers 1
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}

# # expand to open folder
# if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: expand to open folder ... " -NoNewline }
# $tempOutcome1 = Set-RegistryValue -key $key_ExplorerAdvanced -value 'NavPaneExpandToCurrentFolder' -data 1 -type DWORD
# # Set-ItemProperty $key_ExplorerAdvanced NavPaneExpandToCurrentFolder 1
# if ($tempOutcome1) {
# 	if ($showDebugs) { Write-Host " DONE" }
# }
# else {
# 	if ($showDebugs) { Write-Host " ERROR" }
# }

# show full path in title bar
if ($showDebugs) { Write-Host "`n[INFO] configuring Explorer: full path in bar ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_CabinetState -value 'FullPath' -data 1 -type DWORD
# Set-ItemProperty $key_CabinetState FullPath  1
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}


# enable hibernation
if ($showDebugs) { Write-Host "`n[INFO] enabling hibernation ... " -NoNewline }
# powercfg.exe /hibernate on
$tempOutcome1 = Set-RegistryValue -key $key_ControlPower -value 'HibernateEnabled' -data 1 -type DWORD
New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name FlyoutMenuSettings -Force | Out-Null
$tempOutcome2 = Set-RegistryValue -key $key_FlyoutMenuSettings -value 'ShowHibernateOption' -data 1 -type DWORD
$tempOutcome3 = Set-RegistryValue -key $key_FlyoutMenuSettings -value 'ShowLockOption' -data 1 -type DWORD
$tempOutcome4 = Set-RegistryValue -key $key_FlyoutMenuSettings -value 'ShowSleepOption' -data 1 -type DWORD

if ($tempOutcome1 -and $tempOutcome2 -and $tempOutcome3 -and $tempOutcome4) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}


# automatically restart apps after Sign In in Windows
# https://www.tenforums.com/tutorials/138685-turn-off-automatically-restart-apps-after-sign-windows-10-a.html
if ($showDebugs) { Write-Host "`n[INFO] configuring auto-start apps on logon ... " -NoNewline }
$tempOutcome1 = Set-RegistryValue -key $key_Winlogon -value 'RestartApps' -data 1 -type DWORD
if ($tempOutcome1) {
	if ($showDebugs) { Write-Host " DONE" }
}
else {
	if ($showDebugs) { Write-Host " ERROR" }
}


# Chocolatey & packages
$StandardPackages = 'googlechrome',
					'firefox',
					'7zip.install',
					'vlc',
					'dropbox',
					'boxsync',
					'authy-desktop',
					'teamviewer',
					'joplin',
					'openvpn-connect',
					'keepassxc',
					'lightshot',
					'onlyoffice',
					'spotify'
 
if (!Test-Path -Path "$env:ProgramData\Chocolatey") {
	if ($showDebugs) { Write-Host "`n[INFO] installing Choco ... " }
	# InstallChoco
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n=allowGlobalConfirmation

if ($showDebugs) { Write-Host "`n[INFO] installing standard software ... " }
ForEach ($PackageName in $StandardPackages) {
	choco install $PackageName -y
}


$DevPackages =	'notepadplusplus.install',
				'cmder',
				'ConEmu',
				'microsoft-windows-terminal',
				'vim',
				'git.install',
				'vscode.install',
				'python --pre',
				'mobaxterm',
				'winscp.install',
				'arduino',
				'powertoys'

if ($showDebugs) { Write-Host "`n[INFO] installing dev software ... " }
ForEach ($PackageName in $DevPackages) {
	choco install $PackageName -y
}


# configure Windows Terminal
# if ($showDebugs) { Write-Host "`n[INFO] configuring Windows Terminal app ... " }
# TO BE FIXED


# configure Git (add aliases)
if ($showDebugs) { Write-Host "`n[INFO] configuring Git - adding aliases ... " }

git config --global alias.st 'status'
git config --global alias.lga 'log --all --decorate --oneline --graph'
git config --global alias.lg 'log --decorate --oneline --graph'
git config --global alias.lgg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"
git config --global alias.pom 'push origin master'
git config --global alias.poma 'push origin main'
git config --global alias.poh 'push origin $(git rev-parse --abbrev-ref HEAD)'
git config --global alias.amn 'commit --amend --no-edit'
git config --global alias.am 'commit --amend'
git config --global alias.ca 'commit -am'
git config --global alias.cm 'commit -m'


# enable 'OpenSSH Authentication Agent' service
if ($showDebugs) { Write-Host " `n[INFO] configuring 'OpenSSH Authentication Agent' service ... " }
Set-Service -Name ssh-agent -StartupType Automatic
Set-Service -Name ssh-agent -Status Running


# configure Git SSH keys and profiles
# if ($showDebugs) { Write-Host "`n[INFO] configuring Git SSH keys and profiles ... " }
# if ($showDebugs) { Write-Host "`n[ATTENTION] manually create and add the SSH keys in Windows, Git and Git websites!" }