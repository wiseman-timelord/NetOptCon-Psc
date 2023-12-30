REM Script: Netsetera-Psc.Bat
@echo off

:: Initialization
mode con cols=60 lines=30
color 0E
title Netsetera-Psc
cd /d "%~dp0"
echo.
echo Launcher Script Started...
echo.
timeout /t 2 /nobreak >nul

:: Check Admin Rights
echo Checking Admin Rights...
net session >nul 2>&1
if %errorlevel% == 0 (
    echo ...Admin Rights Success.
    echo.
    echo Loading Launcher Menu...
    echo.    
    timeout /t 2 /nobreak >nul
) else (
    echo ...Restart With Admin!
    echo.
    timeout /t 2 /nobreak >nul
    goto end
)

:: Main Menu
:menu
timeout /t 2 /nobreak >nul
cls
echo          ^_   ^_      ^_            ^_                 
echo         ^| \ ^| ^| ^_^_^_^| ^|^_ ^_^_^_  ^_^_^_^| ^|^_ ^_^_^_ ^_ ^_^_ ^_^_ ^_ 
echo         ^|  \^| ^|/ ^_ \ ^_^_/ ^_^_^|/ ^_ \ ^_^_/ ^_ \ '^_^_/ ^_` ^|
echo         ^| ^|\  ^|  ^_^_/ ^|^_\^_^_ \  ^_^_/ ^|^|  ^_^_/ ^| ^| (^_^| ^|
echo         ^|^_^| \^_^|\^_^_^_^|\^_^_^|^_^_^_/\^_^_^_^|\^_^_\^_^_^_^|^_^|  \^_^_,^_^|         
echo ====================( Netsetera-Psc )======================
echo.
echo                   1. Run Netsetera-Psc,
echo                  2. Check File Integrity,
echo                     0. Exit Launcher.
echo.

:: Variables
set /p choice=Select, Options '1-2' or '0' To Exit : 
echo.
if "%choice%"=="1" goto executeMain
if "%choice%"=="2" goto checkScript
if "%choice%"=="0" goto end
echo.
echo Invalid choice. Try again.
pause
goto menu


:: Check for presence of pwsh.exe and execute main.ps1
:executeMain
where pwsh >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Launching as PowerShellCore Script...
    echo.
    timeout /t 2 /nobreak >nul
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1"
    echo ...PowerShellCore Script Exited.
) else (
    echo Launching as PowerShell Script...
    echo.
    timeout /t 2 /nobreak >nul
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1"
    echo ...PowerShell Script Exited.
)
timeout /t 1 /nobreak >nul
goto menu

:: Function to Check File Structure
:checkScript
echo.
echo Checking Script Files...
set missing=0
timeout /t 1 /nobreak >nul

:: Check for PowerShell script files
if not exist ".\scripts\network.ps1" set missing=1
if not exist ".\scripts\updates.ps1" set missing=1
if not exist ".\scripts\cache.ps1" set missing=1
if not exist ".\scripts\backup.ps1" set missing=1
if not exist ".\scripts\settings.psd1" set missing=1
if not exist ".\main.ps1" set missing=1

if %missing%==1 (
    echo ...Failure, Re-Install Program!
) else (
    echo ...Program Files Correct.
)
echo.
timeout /t 2 /nobreak >nul
goto menu

:: End Function
:end
echo.
echo ...Launcher Script Finished.
echo.
pause
