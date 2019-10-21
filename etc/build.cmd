@echo off
rem
rem Builds the app
rem
setlocal
    set DIR_BAS=%CD%
    flutter build apk --split-per-abi
endlocal