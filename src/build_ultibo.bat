@echo off


rem Determine the Ultibo install path from the ULTIBO_DIR variable or use the default
if "%ULTIBO_DIR%"=="" goto defaultpath

set mypath=%ULTIBO_DIR%
set myfpc=%mypath%\bin\i386-win32
goto checkpath

:defaultpath
set mypath=C:\Ultibo\Core\fpc\3.1.1
set myfpc=%mypath%\bin\i386-win32

:checkpath
if not exist %mypath%\nul.x goto patherror
if not exist %myfpc%\fpc.exe goto fpcerror


rem We use FPC to found out the Platform and OS to create a lib output path
%myfpc%\fpc.exe -Parm -Tultibo -iTP > tmpvar
set /p myplatform= < tmpvar
%myfpc%\fpc.exe -Parm -Tultibo -iTO > tmpvar
set /p myos= < tmpvar
del tmpvar

if exist ..\lib\%myplatform%-%myos%\nul.x goto exists

echo Creating missing directory ..\lib\%myplatform%-%myos%
mkdir ..\lib\%myplatform%-%myos%
goto end

:exists
echo Existing output lib directory

:end


rem Determine the board type from the command line (case sensitive) or default to RPI2B
if "%1"=="" goto defaultboard

set myboard=%1
goto checkboard

:defaultboard
set myboard=RPI2B

:checkboard
if "%myboard%"=="RPIA" goto armv6board
if "%myboard%"=="RPIB" goto armv6board
if "%myboard%"=="RPIZERO" goto armv6board
if "%myboard%"=="RPI2B" goto armv7board
if "%myboard%"=="RPI3B" goto armv7board
goto boarderror

:armv6board

%myfpc%\fpc.exe -B -Tultibo -Parm -CpARMV6 -O2 @%myfpc%\RPI.CFG @extrafpc.cfg corelib\ultibo\fpgui_toolkit.pas

:armv7board

%myfpc%\fpc.exe -B -Tultibo -Parm -CpARMV7A -O2 @%myfpc%\RPI2.CFG @extrafpc.cfg corelib\ultibo\fpgui_toolkit.pas

goto noerror

:patherror
echo Error cannot find path "%mypath%"
goto noerror

:fpcerror
echo Error cannot find FPC compiler at "%myfpc%\fpc.exe"
goto noerror

:boarderror
echo Error invalid board type "%myboard%"
goto noerror

:noerror

