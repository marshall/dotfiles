@echo off

REM
REM This needs to run from an administrative cmd.exe
REM 

SET msys2_version_year=2020
SET msys2_version_month=11
SET msys2_version_date=09

SET msys2_dir=%msys2_version_year%-%msys2_version_month%-%msys2_version_date%
SET msys2_stamp=%msys2_version_year%%msys2_version_month%%msys2_version_date%
SET msys2_src_exe=msys2-base-x86_64-%msys2_stamp%.sfx.exe
SET msys2_exe=%cd%/msys2.exe
SET bash=C:\msys64\usr\bin\bash.exe

SET PATH=%PATH%:C:\msys64\usr\bin:C:\msys64\bin

if not exist %bash% (
    echo Downloading %msys2_src_exe%...

    "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; (New-Object System.Net.WebClient).DownloadFile('https://github.com/msys2/msys2-installer/releases/download/%msys2_dir%/%msys2_src_exe%', '%msys2_exe%')"

    echo Installing MSYS2...
    REM Extract to C:\msys64
    "%msys2_exe%" -y -oC:\

    echo Cleanup
    del "%msys2_exe%"

    echo Setup MSYS2..."

    REM Run for the first time
    "%bash%" -lc " "

    REM Update MSYS2
    REM Core update (in case any core packages are outdated)
    "%bash%" -lc "pacman --noconfirm -Syuu" 

    REM Normal update
    "%bash%" -lc "pacman --noconfirm -Syuu"
)

set CHERE_INVOKING=yes
set MSYSTEM=MINGW64
"%bash%" -lc "./bootstrap_mingw.sh"
