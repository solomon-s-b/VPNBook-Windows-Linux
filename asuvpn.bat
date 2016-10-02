@ECHO OFF

openfiles.exe 1>NUL 2>&1
IF NOT %ERRORLEVEL% EQU 0 (
    ECHO You must run this script with admin rights
    EXIT /B 1
)

"%ProgramFiles%"\openvpn\bin\openvpnserv.exe --help >NUL 2>&1
IF ERRORLEVEL 1 (
    ECHO To run this script OpenVPN must be installed!
    ECHO You can download OpenVPN client from the following link:
    ECHO https://openvpn.net/index.php/open-source/downloads.html
    EXIT /B 2
)

"%ProgramFiles%"\7-zip\7z -h >NUL 2>&1
IF ERRORLEVEL 1 (
    ECHO To run this script 7-ZIP must be installed!
    ECHO You can download 7-zip from the following link:
    ECHO http://www.7-zip.org/
    EXIT /B 3
)

SET url="http://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-"
SET urltemp="http://www.vpnbook.com/freevpn"
SET conf="VPNBook.com-OpenVPN-"
SET vbtemp="%USERPROFILE%\vpnbook.tmp"
SET vpnzip="VPNBook.com-OpenVPN-"
SET passfile=%USERPROFILE%\vbpassword.tmp

ECHO Connecting to www.vpnbook.com ...
powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('%urltemp%','%vbtemp%')
FOR /f "tokens=*" %%a IN ('findstr /ic:"<li>Username: <strong>" %vbtemp%') DO FOR /f "tokens=3,4 delims=g>" %%b IN ("%%a") DO FOR /f "tokens=1 delims=<" %%c IN ("%%b") DO SET username=%%c
FOR /f "tokens=*" %%a IN ('findstr /ic:"<li>Password: <strong>" %vbtemp%') DO FOR /f "tokens=3,4 delims=g>" %%b IN ("%%a") DO FOR /f "tokens=1 delims=<" %%c IN ("%%b") DO SET password=%%c
ECHO %username%>%passfile%
ECHO %password%>>%passfile%

ECHO --------------------------------------------
ECHO Username: %username%
ECHO Password: %password%
ECHO --------------------------------------------
ECHO Choose your VPN Server connection destination:
ECHO (1)USA1    (2)USA2    (3)CANADA
ECHO (4)EUROPE1 (5)EUROPE2 (6)GERMANY
ECHO (A)uto     (Q)uit

CHOICE /C 123456AQ /T 10 /D A /M "Please enter your choice:"
IF ERRORLEVEL 8 GOTO END
IF ERRORLEVEL 7 GOTO AUTO
IF ERRORLEVEL 6 GOTO DE1
IF ERRORLEVEL 5 GOTO EURO2
IF ERRORLEVEL 4 GOTO EURO1
IF ERRORLEVEL 3 GOTO CA1
IF ERRORLEVEL 2 GOTO USA2
IF ERRORLEVEL 1 GOTO USA1

:USA1
    SET sv0=US1.zip
    SET sv1=USA1
    SET sv2=us1
GOTO PORT_SELECT

:USA2
    SET sv0=US2.zip
    SET sv1=USA2
    SET sv2=us2
GOTO PORT_SELECT

:CA1
    SET sv0=CA1.zip
    SET sv1=CANADA
    SET sv2=ca1
GOTO PORT_SELECT

:EURO1
    SET sv0=Euro1.zip
    SET sv1=EUROPE1
    SET sv2=euro1
GOTO PORT_SELECT

:EURO2
    SET sv0=Euro2.zip
    SET sv1=EUROPE2
    SET sv2=euro2
GOTO PORT_SELECT

:DE1
    SET sv0=DE1.zip
    SET sv1=GERMANY
    SET sv2=de233
GOTO PORT_SELECT

:PORT_SELECT
    ECHO Choose VPN Server port number:
    ECHO (1)80 (2)443   (Q)uit
    ECHO (3)53 (4)25000

    CHOICE /C 1234Q /M "Please enter your choice:"
    
    IF ERRORLEVEL 5 GOTO END
    IF ERRORLEVEL 4 SET pr=udp25000
    IF ERRORLEVEL 3 SET pr=udp53
    IF ERRORLEVEL 2 SET pr=tcp443
    IF ERRORLEVEL 1 SET pr=tcp80

GOTO RUN

:AUTO
    ECHO Running in auto selection mode...
    SET /A server=%RANDOM% * 6 / 32768 + 1
    SET /A port=%RANDOM% * 4 / 32768 + 1
    IF %server% EQU 1 (
        SET sv0=US1.zip
        SET sv1=USA1
        SET sv2=us1
    )
    IF %server% EQU 2 (
        SET sv0=US2.zip
        SET sv1=USA2
        SET sv2=us2
    )
    IF %server% EQU 3 (
        SET sv0=CA1.zip
        SET sv1=CANADA
        SET sv2=ca1
    )
    IF %server% EQU 4 (
        SET sv0=Euro1.zip
        SET sv1=EUROPE1
        SET sv2=euro1
    )
    IF %server% EQU 5 (
        SET sv0=Euro2.zip
        SET sv1=EUROPE2
        SET sv2=euro2
    )
    IF %server% EQU 6 (
        SET sv0=DE1.zip
        SET sv1=GERMANY
        SET sv2=de233
    )
    IF %port% EQU 1 SET pr=tcp80
    IF %port% EQU 2 SET pr=tcp443
    IF %port% EQU 3 SET pr=udp53
    IF %port% EQU 4 SET pr=udp25000

:RUN
    SET ovpn="%USERPROFILE%\vpnbook-%sv2%-%pr%.ovpn"
    ECHO Connecting to %sv1% VPN server...
    CD %USERPROFILE%
    ECHO Downloading and Extracting config file...
    powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('%url%%sv0%','%vpnzip%%sv0%')
    "%ProgramFiles%"\7-zip\7z x -y %vpnzip%%sv0%
    ECHO. >> %ovpn%
    SET passfile=%passfile:\=\\%
    ECHO auth-user-pass %passfile% >> %ovpn%
    ECHO auth-nocache >> %ovpn%
    "%ProgramFiles%"\openvpn\bin\openvpn %ovpn%

:END
    ECHO Exiting...
    EXIT /B 0
