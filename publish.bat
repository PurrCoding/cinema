@echo off

REM ============================================================
REM Garry's Mod Addon Publishing Script
REM This script packs and updates a workshop addon using
REM gmad.exe and gmpublish.exe. The addon folder is the same
REM directory where this .bat file is located.
REM ============================================================

REM --- Path to Garry's Mod bin tools (adjust if needed) ---
set "basepath=D:\SteamLibrary\common\GarrysMod\bin"
set "gmad=%basepath%\gmad.exe"
set "gmpublish=%basepath%\gmpublish.exe"

REM --- Use the directory of this .bat file as the addon source ---
REM %cd% = drive + path of the script, always ends with a backslash
set "publish_path=%cd%"

REM --- Output .gma name and workshop addon ID ---
set "publish_gma=workshop.gma"
set "publish_id=2419005587"

REM ============================================================
REM CREATE TEMPORARY GAMEMODES LINK
REM ============================================================

REM Create the gamemodes folder if it doesn't exist
if not exist "gamemodes" mkdir "gamemodes"

REM Remove existing junction if present
if exist "gamemodes\cinema_modded" (
    rmdir "gamemodes\cinema_modded"
)

echo Creating temporary junction...
mklink /J "gamemodes\cinema_modded" "%cd%\cinema_modded"

REM ============================================================
REM BUILD .GMA FILE
REM ============================================================

call "%gmad%" create -folder "%publish_path%" -out "%publish_gma%"

REM ============================================================
REM UPLOAD / UPDATE ADDON TO STEAM WORKSHOP
REM ============================================================

call "%gmpublish%" update -addon "%publish_gma%" -id "%publish_id%"

REM ============================================================
REM CLEAN UP
REM ============================================================

echo Waiting 3 seconds before cleanup...
timeout /t 3 /nobreak >nul

echo Removing temporary junction...
rmdir "gamemodes\cinema_modded"

echo Removing temporary gamemodes directory...
rmdir "gamemodes"

del "%publish_gma%"

pause