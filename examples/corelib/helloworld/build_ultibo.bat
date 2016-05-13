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

%myfpc%\fpc.exe -dRPI -B -Tultibo -Parm -CpARMV6 -O2 -WpRPiB @%myfpc%\RPI.CFG @extrafpc.cfg helloworld_ultibo.pas

:armv7board

%myfpc%\fpc.exe -dRPI2 -B -Tultibo -Parm -CpARMV7A -O2 -WpRPi2B @%myfpc%\RPI2.CFG @extrafpc.cfg helloworld_ultibo.pas

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
