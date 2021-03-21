@ECHO off

@REM ### CONFIG ###
SET scriptURL=https://raw.githubusercontent.com/TaylorJadin/valheim-plus-installer/main/valheim-plus-installer.ps1
SET scriptName=valheim-plus-installer.ps1
@REM ### ###### ###

SET scriptFile=%TEMP%/%scriptName%
powershell -Command "Invoke-WebRequest %scriptURL% -OutFile %scriptFile%"
powershell -executionpolicy unrestricted -File  %scriptFile%