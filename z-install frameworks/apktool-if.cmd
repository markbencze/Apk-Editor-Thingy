@ECHO OFF
COLOR C
if "%1"=="" goto usage
cd /d "%~dp0"
echo.
echo  Processing...
echo.

:getfile
if "%1"=="" goto alldone
java -jar apktool.jar if "%1"
if errorlevel 1 goto error
echo    %~nx1 - installed
shift
goto getfile

:error
echo.
echo  !!!Aborted!!!
goto end

:usage
echo.
echo  How to use this file:
echo   Drop file(s) on this file, or type "%~nx0 "D:\full\path\to\file1.ext" "D:\full\path\to\file2.ext" ..."
goto end

:alldone
echo.
echo  All done!

:end
echo.
pause