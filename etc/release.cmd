@echo off
rem
rem Builds the app for releasing
rem
setlocal
    set DIR_BAS=%CD%
    call flutter clean
    call flutter build appbundle --release
endlocal