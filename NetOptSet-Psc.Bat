REM Script: NetOptSet-Psc.Bat
@echo off

:: Initialization
mode con cols=60 lines=30
color 0E
title NetOptSet-Psc Launcher
echo.
echo Launcher Script Started...

REM Function
:menu
timeout /t 2 /nobreak >nul
cls
echo        ^_   ^_      ^_    ^_^_^_        ^_   ^_^_^_^_       ^_   
echo       ^| \ ^| ^| ^_^_^_^| ^|^_ / ^_ \ ^_ ^_^_ ^| ^|^_/ ^_^_^_^|  ^_^_^_^| ^|^_ 
echo       ^|  \^| ^|/ ^_ \ ^_^_^| ^| ^| ^| '^_ \^| ^_^_\^_^_^_ \ / ^_ \ ^_^_^|
echo       ^| ^|\  ^|  ^_^_/ ^|^_^| ^|^_^| ^| ^|^_) ^| ^|^_ ^_^_^_) ^|  ^_^_/ ^|^_ 
echo       ^|^_^| \^_^|\^_^_^_^|\^_^_^|\^_^_^_/^| .^_^_/ \^_^_^|^_^_^_^_/ \^_^_^_^|\^_^_^|
echo                            ^|^_^|           
echo ====================( NetOptSet-Psc )======================
echo.
echo                   1. Start NetOptSet-Psc,
echo                   2. Check File Structure,
echo                      0. Exit Launcher.
echo.

REM Variables
set /p choice=Select, Options '1-2' or '0' To Exit : 
if "%choice%"=="1" goto startScript
if "%choice%"=="2" goto checkScript
if "%choice%"=="0" goto end
echo Invalid choice. Try again.
pause
goto menu

REM Function
:startScript
echo.
echo.
:: Check for presence of pwsh.exe
where pwsh >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Launching as PowerShellCore Script...
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1"
    echo ...PowerShellCore Script Exited.
) else (
    echo Launching as PowerShell Script...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1"
    echo ...PowerShell Script Exited.
)
timeout /t 1 /nobreak >nul
goto end

REM Function
:checkScript
echo.
echo.
set missing=0
echo Checking Required Script Files...
timeout /t 1 /nobreak >nul

REM Check for PowerShell script files
if not exist ".\scripts\network.ps1" set missing=1
if not exist ".\scripts\updates.ps1" set missing=1
if not exist ".\scripts\cache.ps1" set missing=1
if not exist ".\scripts\backup.ps1" set missing=1
if not exist ".\scripts\settings.psd1" set missing=1
if not exist ".\main.ps1" set missing=1

if %missing%==1 (
    echo.
    echo File Structure: Incorrect!
) else (
    echo.
    echo File Structure: Correct!
)
echo.
timeout /t 2 /nobreak >nul
goto menu

REM Function
:end
echo.
echo ...Launcher Script Finished.
echo.
pause
