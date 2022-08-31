@echo off
REM ===========================================================================
REM Neue Steuerung des NEUEN autoupdates ber ein Impulse von aussen ber eine 
REM Steuerdatei mit dem Namen alfavm-XXX.txt
REM 17.09.2012 Wa
rem 04.04.2019 MP: MSG2 auskommentiert
REM ===========================================================================

if exist ../alfaProperties.bat call ../alfaProperties.bat

rem Prüfen ob der Batch auf einem TS aufgerufen wird
if %RDS_SERVER%!==! goto STARTPC
@echo Variable RDS_SERVER hat folgenden Wert: %RDS_SERVER%
if not %RDS_SERVER%==YES goto STARTPC


rem Bei USERNAME=administrator darf das file alfa_vm.ini nicht APPDATA kopiert werden, das macht Probleme,
rem sondern es muss nach \temp kopiert werden, aber nur auf dem TS

REM if not %USERNAME%==administrator goto ADMIN

rem auf dem TS darf der User keine autoupdate aufrufen!
if not %USERNAME%==administrator goto ohneup

rem @echo Ich bin bei :ADMIN
rem pause

if not exist "%AVMROOT%\temp\%username%_alfa_vm.ini" copy alfa_vm.ini "%AVMROOT%\temp\vm_%username%.ini" /V /Y >NUL

start "" "%AVMROOT%\alfa_vm.exe" -ini "%AVMROOT%\temp\vm_%username%.ini"


GOTO ENDE



:STARTPC
rem @echo STARTPC
rem pause 
rem Parameter setzen wg. Printmanager und ALFA-VM

set wa_alfa=ALFA-VM
if exist \\intern.stimme.de\fileserver\daten\kommerz\vertrieb\alfbatch\alfa_vmNu.bat call \\intern.stimme.de\fileserver\daten\kommerz\vertrieb\alfbatch\alfa_vmNu.bat

set wa_alfa=
@echo off

if not exist \\intern.stimme.de\fileserver\daten\kommerz\vertrieb\alfbatch\alfa_vmNu.bat goto msg1

rem if not exist f:\kommerz\vertrieb\alfbatch\alfa_vmNu.bat goto msg2

goto ohneup

:msg1
@echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
@echo บ Aufruf von ALFA-VM                                                     บ
@echo ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
@echo บ                                                                        บ
@echo บ ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!        บ
@echo บ                                                                        บ
@echo บ Das Netzlaufwerk \\intern.stimme.de\fileserver\daten\kommerz\vertrieb\alfbatchบ 
@echo บ ist nicht vorhanden !!!                                                บ
@echo บ Es kann nicht ueberprueft werden, ob eine neue Version von alfa-vm     บ
@echo บ vorliegt.                                                              บ
@echo บ                                                                        บ
@echo บ Melden Sie dies bitte Ihrem Systemadministrator                        บ
@echo บ                                                                        บ
@echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
pause
goto ohneup

rem msg2
rem @echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
rem @echo บ Aufruf von ALFA-VM                                                     บ
rem @echo ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
rem @echo บ                                                                        บ
rem @echo บ ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!  ACHTUNG !!!        บ
rem @echo บ                                                                        บ
rem @echo บ Das Netzlaufwerk f:\kommerz\vertrieb\alfbatch ist nicht vorhanden !!!  บ
rem @echo บ Alfa-VM kann u.U. die Daten nicht korrekt ablegen!                     บ
rem @echo บ                                                                        บ
rem @echo บ Melden Sie dies bitte Ihrem Systemadministrator                        บ
rem @echo บ                                                                        บ
rem @echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
rem pause
rem goto ohneup
rem 

:ohneup

if not defined AVMROOT set AVMROOT=%N2ROOT%\alfa-vm

if not exist "%APPDATA%\alfa_vm.ini" copy alfa_vm.ini "%APPDATA%" /V /Y >NUL


start "" "%AVMROOT%\alfa_vm.exe" -ini "%APPDATA%\alfa_vm.ini"

:ENDE
