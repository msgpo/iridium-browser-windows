@echo off
rem Compile release distribution packages

cd develop

if "%1" == "x64" (
    echo Compiling 64bit installer...
    set RELEASE_FOLDER=src\out\Release_x64
) else (
    echo Compiling 32bit installer...
    set RELEASE_FOLDER=src\out\Release
)

rem Need to delete old manifest files so they are not included in the installer
if exist %RELEASE_FOLDER%\*.manifest (
    del /q %RELEASE_FOLDER%\*.manifest
)
ninja -C %RELEASE_FOLDER% chrome.7z
if not %errorlevel% == 0 (
    exit /b 1
)

echo Building FFmpeg with free codecs
set OLD_GYP_DEFINES=%GYP_DEFINES%
set GYP_DEFINES=%OLD_GYP_DEFINES% ffmpeg_branding=Chromium
call python src\build\gyp_chromium src\third_party\ffmpeg\ffmpeg.gyp
ninja -C %RELEASE_FOLDER% ffmpegsumo
if not %errorlevel% == 0 (
    exit /b 1
)
copy /y %RELEASE_FOLDER%\ffmpegsumo.dll %RELEASE_FOLDER%\ffmpegsumo-free.dll >NUL

echo Building FFmpeg with proprietary codecs
set GYP_DEFINES=%OLD_GYP_DEFINES% ffmpeg_branding=Chrome
call python src\build\gyp_chromium src\third_party\ffmpeg\ffmpeg.gyp
ninja -C %RELEASE_FOLDER% ffmpegsumo
if not %errorlevel% == 0 (
    exit /b 1
)
copy /y %RELEASE_FOLDER%\ffmpegsumo.dll %RELEASE_FOLDER%\ffmpegsumo-extra.dll >NUL
