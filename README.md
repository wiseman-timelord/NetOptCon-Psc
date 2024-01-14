# Netsetera-Psc
## STATUS
- Alpha. Do not use, the files are present for backup purposes ONLY, and will likely break, something or itself. Please Wait.
- Outstanding work...
1. Idea - Performance benchmark instead of performance testing. See how fast it download, with limit of 1 minute, present results, how long expired, how much was downloaded, score in MB downloaded, if finish early then predict how many MB would be achieved and add on, and also deduct 1 point for each, error and discard. This is now delaying the project.
2. Figure out what URLS work, remove rest, add option to enter a URL (futureproof).

## DESCRIPTION
Netsetera-Psc is a comprehensive PowerShell script for managing network settings, Windows updates, cache, and backup/restore functionalities. It offers a user-friendly menu-driven interface, and includes various functional modules for specific tasks like tweaking network settings, managing Windows updates, handling cache for different browsers, and backing up/restoring configuration settings. The accompanying settings.psd1 file provides a centralized location for configurable settings, enhancing the script's adaptability to different environments or requirements.

## FEATURES
- Menu-driven interface for easy navigation.
- Comprehensive network tweak options.
- Windows update management, including Edge updates.
- Cache management for DNS and popular browsers.
- Performance/Errors Testing feature, run a download in background.
- Backup and restore functionality for settings.

## Preview
```
=====================( Netsetera-Psc )=====================
=======================( Main Menu )=======================

                    1. Network Tweaks
                    2. Windows Updates
                   3. Cache Management
                   4. Network Benchmark
                   5. Backup And Restore

Select, Options=1-5, Return=X:

```

## INSTRUCTIONS
1) Download the Package: Download the package and extract it to a dedicated folder.
2) Run `Netsetera.Bat` with Admin rights (Right click it and select `Run with Admin`).
3) Run a Benchmark to test your network speed.
4) Utilize the Backup function, so, as required, you can restore settings later.
5) Navigate menu, select your interests.
6) Navigate menus to `Exit Program`, and then restart computer.
7) Run `Netsetera.Bat` again, and run the benchmark again, to see, that the tweaking of system settings has made negligable difference.

## REQUIREMENTS
- Windows 7/8.1/10/11 (Limited features for Windows 7).
- Powershell Core (Powershell Non-Core un-tested)
- Administrator Rights

## NOTATIONS
- If you are benchmarking a wireless connection, then please understand, that it is near impossible to get repeatable results between benchmarks; a slower result after benchmark, may infact still mean it is faster for general use.
- Netsetera-Psc program was created out of combining my programs, "EdgeNoUpdate" and "AirTweak" and "NetForm" and unreleased "NetOpt", and is intended to combine the, features and functions, of all of them, while to be having a few improvements along the way.

## DISCLAIMER
The "License.Txt" covers, this and relating, stuff.
