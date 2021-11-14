#-------------------------------------------------------------------------------------
# Script: 		syncFromOneDrice.ps1
#
# Description: 	Waits for 'Cloud' disk and then robocopies the earthporn synced pics
#				from Android backup folder into local Pictures folder.
#               
# Arguments: 	[4]:    -showDebugs     : [switch] show debugging messages in console
#                       -notTouch       : [switch] don't copy files - just create logs
#
# Created:		21/08/2019
# Author: 		Apostolos Smyrnakis
#-------------------------------------------------------------------------------------

param(
    [switch]$showDebugs = $false,
    [switch]$notTouch = $false
)

$counterCheck = 0
$pathOneDrive = 'U:\OneDrive\διάφορα\Android\OnePlus6\Tasker\bkp\data\img\earthporn'
$pathLocalPic = 'C:\Users\tolar\Pictures\EarthPorn\pics'


if ($showDebugs) { Write-Host "`n Testing if 'Cloud' drive is connected ...`n" }

# Write-Host " pathOneDrive : $pathOneDrive"
# Write-Host " pathLocalPic : $pathLocalPic"

while (($counterCheck -lt 4) -AND (-NOT (Test-Path -LiteralPath $pathOneDrive))) {
	$counterCheck += 1
	
	if ($showDebugs) { Write-Host "`n 'Cloud' drive is not available. Checking again in 15 sec...`n" }
	Start-Sleep -Seconds 15
}

if (Test-Path -LiteralPath $pathOneDrive) {

	$roboLogPath = 'C:\Users\tolar\Pictures\EarthPorn\robocopyLOG.txt'

	if ($notTouch) {
		if ($showDebugs) { Write-Host "`n`nnotTouch=true --> RoboCopy will only LIST the files.`n" }

		# ,"/ZB"
		$what        = @("/L","/E","/COPY:DAT")   # Using /L switch : just test / log files
	}
	else {
		$what        = @("/E","/COPY:DAT") 
	}

	$options     = @("/R:10","/W:2","/NP","/FFT","/XA:SHT","/UNILOG+:$roboLogPath")  # ,"/NFL"
	# $exclusions  = @("/XF","desktop.ini","Thumbs.db","*._sync_*","*.owncloud*","/XD","`$RECYCLE.BIN","AppData","Application Data","Cookies","Local Settings","NetHood","PrintHood","Recent","Searches","SendTo","Start Menu","Templates")

	$cmdArgs     = @($pathOneDrive,"$pathLocalPic",$what,$options)

	if ($showDebugs) {
		$timeStart = (get-date).ToString('HH:mm:ss.fff') #Get-Date -UFormat "%H:%M:%S.%fff" 
		Write-Host -NoNewline "`n Copy started at $timeStart . . . . . . "
	}

	$robocopyExitCode = robocopy @cmdArgs

	if ($showDebugs) {
		$timeEnd = (get-date).ToString('HH:mm:ss.fff') #Get-Date -UFormat "%H:%M:%S.%fff"
		Write-Host -NoNewline " $timeEnd finished!`n`n"
	}
	
	if ($robocopyExitCode -lt 7) {
		if ($showDebugs) {
			# Write-Host "`n Robocopy exit code: $robocopyExitCode" 
			Write-Host "`n Script finished successfully. Exiting.`n"
		}
		
		Exit 0
	}
	else {
		if ($showDebugs) {
			# Write-Host "`n Robocopy exit code: $robocopyExitCode" 
			Write-Host "`n Script finished with errors!`n"
		}
		
		Exit $robocopyExitCode
	}
}
else {
	if ($showDebugs) { Write-Host "`n 'Cloud' drive is not available after 4 checks. Exiting!`n" }
	
	Exit -1
}

# Fail-safe exit
Exit -1