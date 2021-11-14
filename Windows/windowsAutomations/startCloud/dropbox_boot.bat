@echo off
mode con:cols=65 lines=25
color 0c
title Waiting Cloud disk mount...
rem Checking to see if volume is mounted
echo.
rem echo  Welcome, %USERNAME%!
echo  Welcome, Apostolos!
echo.
echo  Waiting for Cloud disk . . . 
echo.
:waiting
ping -n 1 -w 1000 127.0.0.1 > nul
if not exist U:\ goto waiting
echo.
:noNetwork
ping -n 1 -w 1000 8.8.8.8
if errorlevel 1 goto noNetworkQ
echo.
:startApps
echo  Starting applications . . .
timeout 3 > nul
rem ping 127.0.0.1 -n 3 > nul
echo.
rem start "Dropbox" "C:\Users\8C40~1\AppData\Roaming\Dropbox\bin\Dropbox.exe"
start "Dropbox" "C:\Program Files (x86)\Dropbox\Client\Dropbox.exe"
echo  - Dropbox started!
echo.
start "OneDrive" "C:\Users\tolar\AppData\Local\Microsoft\OneDrive\OneDrive.exe"
echo  - OneDrive started!
echo.
start "BoxSync" "C:\Program Files\Box\Box Sync\BoxSync.exe"
echo  - BoxSync started!
echo.
echo.
echo  Exiting in 4 seconds...
timeout 4
exit

:noNetworkQ
echo.
echo  No network connection! Start applications?
set /p answer= " (Yes/No/Retry): "
if "%answer%"=="Y" goto startApps
if "%answer%"=="y" goto startApps
if "%answer%"=="N" exit
if "%answer%"=="n" exit
if "%answer%"=="R" goto waiting
if "%answer%"=="r" goto waiting
echo.
echo Invalid selection: %answer%
goto noNetworkQ