@echo off
color 02
set /A ip=42
mode con: cols=120 lines=25
goto :start
:: BatchGotAdmin

:-------------------------------------

REM --> Check for permissions

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"



REM --> If error flag set, we do not have admin.

if '%errorlevel%' NEQ '0' (

echo Requesting administrative privileges...

goto UACPrompt

) else ( goto gotAdmin )



:UACPrompt

echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

set params = %*:"=""

echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"



"%temp%\getadmin.vbs"

del "%temp%\getadmin.vbs"

exit /B



:gotAdmin

pushd "%CD%"

CD /D "%~dp0"

:--------------------------------------
@ECHO off
:start
ECHO.
ECHO.
ECHO                              ////////////////////////////////////////////////
ECHO                                     S C H N E I D E R   E L E C T R I C
ECHO                              \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
ECHO.
ECHO.
echo Selezionare a quale dispositivo ci si vuole connettere, l'indirizzo ip verra' cambiato automaticamente.
ECHO.

::Inserire il nome qui (se avete fatto modifiche)
ECHO Made by: Michael, Marco, Gabriele. 
ECHO.
ECHO L'indirizzo ip impostato e' x.x.x.%ip%
ECHO.
ECHO 1. Com'X 510 
ECHO 2. PowerTag Link
ECHO 3. IFE Gateway 
ECHO 4. EGX300
ECHO 5. IP manuale
ECHO 6. DHCP (IP dinamico)
ECHO 7. ip config
ECHO 8. exit
ECHO.
ECHO.
set choice=
set /p choice=Digita il numero della voce selezionata: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto comx
if '%choice%'=='2' goto powerlink
if '%choice%'=='3' goto ifegw
if '%choice%'=='4' goto egx300
if '%choice%'=='5' goto setip
if '%choice%'=='6' goto dynip
if '%choice%'=='7' goto ipconf
if '%choice%'=='8' goto bye
ECHO "%choice%" Nope
ECHO.
goto start

:comx
ECHO Com'X 510 Computer ip: 10.25.1.%ip%
netsh interface ip set address "Ethernet" static 10.25.1.%ip% 255.255.0.0
ECHO. 
timeout 2 
goto start

:powerlink
ECHO PowerTag Link Computer ip: 169.254.249.%ip%
netsh interface ip set address "Ethernet" static 169.254.249.%ip% 255.255.0.0 
ECHO.
timeout 2 
goto start

:ifegw
ECHO IFE Gateway Computer ip: 169.254.187.%ip% 
netsh interface ip set address "Ethernet" static 169.254.187.%ip% 255.255.0.0 
ECHO.
timeout 2 
goto start


:egx300
ECHO EGX300 ip: 169.254.0.%ip% 
netsh interface ip set address "Ethernet" static 169.254.0.%ip% 255.255.255.0 
ECHO.
timeout 2 
goto start

:setip
ECHO L'indirizzo ip impostato e' x.x.x.%ip%
ECHO.
set /p ip2= Digita l'ip che si desidera utilizzare sull'ultimo ottetto. e.g. x.x.x.IP: 
SET ip=%ip2%
ECHO.
ECHO Il nuovo indirizzo ip impostato e' x.x.x.%ip%
timeout 2 
goto start

:dynip
ECHO DHCP
ECHO.
ECHO Reset dell'IP e la Subnet Mask con il DHCP
ECHO.
netsh int ip set address name = "Ethernet" source = dhcp
ECHO.
ECHO Reset DNS con il DHCP
ECHO.
netsh int ip set dns name = "Ethernet" source = dhcp
timeout 2 
goto start

:ipconf
ipconfig
cls
ipconfig
cls
ipconfig
pause 
goto start

:bye
ECHO Exit?
ECHO n - No
ECHO y - Si
choice /c nyr /n
If %ErrorLevel%==1 goto start
If %ErrorLevel%==2 goto kill

:kill
ECHO.
ECHO Bye bye by dgz
timeout 3
exit 0
