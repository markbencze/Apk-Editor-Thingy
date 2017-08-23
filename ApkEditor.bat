@echo off
setlocal enabledelayedexpansion
COLOR 7
if (%1)==(0) goto skipme
echo -------------------------------------------------------------------------- >> log.txt
echo ^|%date% -- %time%^| >> log.txt
echo -------------------------------------------------------------------------- >> log.txt
ApkEditor 0 2>> log.txt
:skipme
cd "%~dp0"
mode con:cols=105 lines=50

IF NOT EXIST "projects". (mkdir projects)
IF NOT EXIST "place-apk-here-for-modding". (mkdir place-apk-here-for-modding)

cls
set usrc=9
set dec=0
set capp=None
set heapy=5000
set decojar=apktool_2.2.4.jar
set recojar=apktool_2.2.4.jar
java -version 
if errorlevel 1 goto errjava
set /A count=0
FOR %%F IN (place-apk-here-for-modding/*.apk) DO (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
if %count%==1 (set capp=%tmpstore%)
cls
:restart
cd "%~dp0"
set menunr=GARBAGE
cls
echo  _______________________________________________________________________________
echo  ^| Compression-Level: %usrc% ^|   Heap Size: %heapy%mb ^|   Current-App:%capp% ^|
echo  _______________________________________________________________________________
echo  			 Mark's Apk Editor V 2.2.4
echo  _______________________________________________________________________________
echo  			         Options
echo                         #BlackScreenOS is Coming
echo							
echo  _______________________________________________________________________________
echo  1   Decompile apk
echo  2   Compile apk
echo  3   Sign apk 
echo  4   Set Max Memory Size
echo  5   Read the log because you screwed up!
echo  6   Set current project
echo  _______________________________________________________________________________
SET /P menunr=Please make your decision:
IF %menunr%==4 (goto heap)
IF %menunr%==5 (goto logr)
IF %menunr%==6 (goto filesel)
IF %menunr%==7 (goto about)
if %capp%==None goto noproj
IF %menunr%==1 (goto de)
IF %menunr%==2 (goto co)
IF %menunr%==3 (goto si)
:WHAT
echo What are you doing??? Try again!!!
PAUSE
goto restart
:heap
set /P INPUT=Enter max size for java heap space in megabytes (eg 512) : %=%
set heapy=%INPUT%
cls
goto restart
:usrcomp
set /P INPUT=Enter Compression Level (0-9) : %=%
set usrc=%INPUT%
cls
goto restart
:filesel
cls
set /A count=0
FOR %%F IN (place-apk-here-for-modding/*.apk) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^- !count!  - %%F )
if /I !count! GTR 9 (echo ^- !count! - %%F )
)
echo.
echo Choose the app to be set as current project?
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto chc)
if /I %INPUT% LSS 1 (goto chc)
set capp=!a%INPUT%!
goto restart
:chc
set capp=None
goto restart
:dirnada
echo %capp% has not been extracted, please do so before doing this step
PAUSE
goto restart
:noproj
echo Please select a project to use Apk Editor on (option #6)
PAUSE
goto restart
:de
IF NOT EXIST "%~dp0projects\%capp%" GOTO degood
echo This project already exists - overwrite?^(y/n^)
set /P OVWRCH=Type input: %=%
if %OVWRCH%==y (goto degood)
goto restart
:degood
cd platform-tools
DEL /Q "../place-apk-here-for-modding/signed%capp%"
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
IF EXIST "../projects/%capp%" (rmdir /S /Q "../projects/%capp%")
echo Decompiling apk
java -Xmx%heapy%m -jar %decojar% d "../place-apk-here-for-modding/%capp%" -o "../projects/%capp%"
if errorlevel 1 (
echo "An error occured, please check the log to see what you screwed up!(option #5 and then open the txt file to read the log)"
PAUSE
)
cd ..
goto restart
:co
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd platform-tools
echo Building apk
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
IF EXIST "%~dp0projects\%capp%\build" (rmdir /S /Q "%~dp0projects\%capp%\build")
java -Xmx%heapy%m -jar %recojar% b "../projects/%capp%" -o "%~dp0place-apk-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An error occured, please check the log to see what you screwed up!(option #5 and then open the txt file to read the log)"
PAUSE
goto restart
)
echo Is this a system apk ^(y/n^)
set /P INPU=Type input: %=%
if %INPU%==n (goto q1)
:nq1
echo Aside from the signatures, would you like to copy
echo over any additional files that you didn't modify
echo from the original apk in order to ensure least 
echo # of errors ^(y/n^)
set /P INPUT1=Type input: %=%
if %INPUT1%==y (call :nq2)
if %INPUT1%==n (call :nq3)
:nq2
rmdir /S /Q "%~dp0keep"
7za.exe x -o"../keep" "../place-apk-here-for-modding/%capp%"
echo In the Apk Editor root folder you'll find
echo a keep folder. Within it, delete 
echo everything you have modified and leave
echo files that you haven't. If you have modified
echo any xml, then delete resources.arsc from that 
echo folder as well - if you modified smali files, 
echo then delete classes.dex. Once done then press 
echo enter on this script.
PAUSE
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*" -mx%usrc% -r
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*.ogg" -mx0 -r
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*.wav" -mx0 -r
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*.png" -mx0 -r
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*.jpg" -mx0 -r
IF NOT EXIST "%~dp0keep\resources.arsc" ( 7za.exe x -o"../keep" "../place-apk-here-for-modding/unsigned%capp%" *.arsc -r )
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*.arsc" -mx0 -r
rmdir /S /Q "%~dp0keep"
zipalign.exe 4 "../place-apk-here-for-modding/unsigned%capp%" "../place-apk-here-for-modding/unsigned%capp%.new"
MOVE /Y "../place-apk-here-for-modding/unsigned%capp%.new" "../place-apk-here-for-modding/unsigned%capp%"
cd ..
goto restart
:nq3
7za.exe x -o"../projects/temp" "../place-apk-here-for-modding/%capp%" META-INF -r
7za.exe a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/temp/*" -mx%usrc% -r
rmdir /S /Q "%~dp0projects/temp"
cd ..
goto restart
:q1
echo Would you like to copy over any additional files 
echo that you didn't modify from the original apk in order to ensure least 
echo # of errors ^(y/n^)
set /P INPU=Type input: %=%
if %INPU%==y (goto nq2)
cd ..
goto restart
:si
cd tools
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An error occured, please check the log to see what you screwed up!(option #5 and then open the txt file to read the log)"
PAUSE
cd ..
goto restart
)
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
goto restart
:errjava
cls
echo Java was not found, you will not be able to sign apks or use Tinker Tool
PAUSE
goto restart
:logr
cd tools
Start "Read The Log - Main script is still running, close this to return" signer 1
cd ..
goto restart
:quit
exit
