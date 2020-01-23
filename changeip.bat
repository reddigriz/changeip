@echo off


goto start
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
echo Selezionare a quale dispositivo ci si vuole connettere, l'indirizzo ip verra' cambiato automaticamente.
ECHO.
ECHO 1. Com'X 510 
ECHO 2. PowerTag Link
ECHO 3. IFE Gateway 
ECHO 4. EGX300
ECHO 5. Obtain an IP address automatically
ECHO 6. Exit
set choice=
set /p choice=Type the number to print text.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto con1
if '%choice%'=='2' goto con2
if '%choice%'=='3' goto con3
if '%choice%'=='4' goto con4
if '%choice%'=='5' goto autosearch
if '%choice%'=='6' goto bye
ECHO "%choice%" Nope
ECHO.
goto start

:con1
ECHO Com'X 510 Computer ip: 10.25.1.242
netsh interface ip set address "Ethernet" static 10.25.1.242 255.255.0.0
ECHO. 
pause 
goto start

:con2
ECHO PowerTag Link Computer ip: 169.254.249.242
netsh interface ip set address "Ethernet" static 169.254.249.242 255.255.0.0 
ECHO.
pause 
goto start

:con3
ECHO IFE Gateway Computer ip: 169.254.187.242 
netsh interface ip set address "Ethernet" static 169.254.187.242 255.255.0.0 
ECHO.
pause 
goto start


:con4
ECHO EGX300 ip: 169.254.0.242 
netsh interface ip set address "Ethernet" static 169.254.0.242 255.255.255.0 
ECHO.
ECHO.
pause 
goto start

:autosearch
ECHO DHCP
ECHO Resetting IP Address and Subnet Mask For DHCP
netsh int ip set address name = "Ethernet" source = dhcp
ECHO Resetting DNS For DHCP
netsh int ip set dns name = "Ethernet" source = dhcp
pause 
goto start

:bye
set exit=
ipconfig
cls
ipconfig
ECHO.
choice /c nyr /n /m "Exit? n/y/r(epeat ip config)
If %ErrorLevel%==1 goto start
If %ErrorLevel%==2 goto kill
If %ErrorLevel%==3 goto bye

:kill
ECHO.
ECHO Bye bye by dgz
ECHO.
exit 0