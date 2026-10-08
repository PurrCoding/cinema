@echo off
setlocal EnableExtensions

rem ============================================================
rem Build and publish the Cinema gamemode to the Steam Workshop.
rem The temporary gamemodes junction is required so gmad includes
rem cinema_modded in the addon package.
rem ============================================================

rem Run from the directory containing this script, regardless of
rem the directory the caller launched it from.
pushd "%~dp0" || (
    echo ERROR: Could not enter the publishing directory.
    exit /b 1
)
set "publish_path=%CD%"

rem Adjust this path if Garry's Mod is installed elsewhere.
set "gmod_bin=D:\SteamLibrary\common\GarrysMod\bin"
set "gmad=%gmod_bin%\gmad.exe"
set "gmpublish=%gmod_bin%\gmpublish.exe"

set "publish_gma=workshop.gma"
set "publish_id=2419005587"
set "junction=gamemodes\cinema_modded"
set "created_gamemodes=0"
set "created_junction=0"
set "result=1"

rem Check required tools and source folder before changing anything.
if not exist "%gmad%" (
    echo ERROR: gmad.exe was not found: "%gmad%"
    goto :cleanup
)
if not exist "%gmpublish%" (
    echo ERROR: gmpublish.exe was not found: "%gmpublish%"
    goto :cleanup
)
if not exist "%publish_path%\cinema_modded\" (
    echo ERROR: Source folder was not found: "%publish_path%\cinema_modded"
    goto :cleanup
)

rem Create the parent directory only when needed.
if not exist "gamemodes\" (
    mkdir "gamemodes" || (
        echo ERROR: Could not create the gamemodes directory.
        goto :cleanup
    )
    set "created_gamemodes=1"
)

rem Do not overwrite a real directory or an existing junction.
if exist "%junction%" (
    echo ERROR: "%junction%" already exists.
    echo Remove the stale junction manually, then run this script again.
    goto :cleanup
)

echo Creating temporary gamemodes junction...
mklink /J "%junction%" "%publish_path%\cinema_modded"
if errorlevel 1 (
    echo ERROR: Could not create the temporary junction.
    goto :cleanup
)
set "created_junction=1"

echo.
echo Building "%publish_gma%"...
"%gmad%" create -folder "%publish_path%" -out "%publish_gma%"
if errorlevel 1 (
    echo ERROR: gmad failed to build the addon.
    goto :cleanup
)
if not exist "%publish_gma%" (
    echo ERROR: gmad did not create "%publish_gma%".
    goto :cleanup
)

echo.
echo Uploading addon to Steam Workshop...
"%gmpublish%" update -addon "%publish_gma%" -id "%publish_id%"
if errorlevel 1 (
    echo ERROR: Steam Workshop publishing failed.
    goto :cleanup
)

set "result=0"
echo.
echo Publishing completed successfully.

:cleanup
echo.
if "%created_junction%"=="1" (
    echo Removing temporary junction...
    rmdir "%junction%"
)
if "%created_gamemodes%"=="1" (
    echo Removing temporary gamemodes directory...
    rmdir "gamemodes" 2>nul
)
if exist "%publish_gma%" (
    echo Removing temporary package...
    del "%publish_gma%"
)
popd
if "%result%"=="0" (
    pause
)
exit /b %result%
