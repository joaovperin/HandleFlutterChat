@echo off
rem
rem Installs the app
rem
setlocal
    set DIR_BAS=%CD%
    set ART_NAME=app-arm64-v8a-release

    adb install -r %DIR_BAS%\build\app\outputs\apk\release\%ART_NAME%.apk
endlocal