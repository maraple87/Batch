#wählt die aktuellste Datei aus
$logdatei = Get-ChildItem ReportServerService* | Sort CreationTime -Descending | select -First 1 
#Logdateinamen speichern
$name = Get-ChildItem ReportServerService*  -name | Sort CreationTime -Descending | select -First 1 

#Durchsucht eine Datei nach allen Fehlermeldungen
$body = Select-String -path $logdatei -Pattern 'error' 

#Da der Pfad + Datename bei select-String mit abgespeichert wird, entfernen wir ihn
$body = $body -replace ".*log:",""

#Leere Zeile zwischen den Fehlermeldungen
$body = $body -replace ";",";`n`n"

#zur Hilfe für weitere Bearbeitung in Textdatei speichern
$body.trim() >> tmp.txt


$nl = [Environment]::NewLine


#Folgend werden nacheinander alle unwichtige Fehlermeldungen entfernt:
#--------------------------------------------

#alle mit den Meldungen über Funktionalität:
$body = Select-String -path tmp.txt -pattern 'Funktionalit*' -notmatch  | ForEach-Object {$_.Line}| Foreach {"$_$nl"}| Foreach {"$_$nl"}

#Da der Pfad + Datename bei select-String mit abgespeichert wird, entfernen wir ihn
$body = $body -replace ".*txt:",""

#Leere Zeile zwischen den Fehlermeldungen
#$body = $body -replace ";",";`n`n"
$body.trim() >> tmp1.txt

#---------------------------------------------

#alle mit den Meldungen über Konfigurationsfehler. ForEach-Object {$_.Line} entfernt die Zeilenzahlen 
$body = Select-String -path tmp1.txt -pattern 'Konfigurationsfehler' -notmatch  | ForEach-Object {$_.Line}| Foreach {"$_$nl"}| Foreach {"$_$nl"}

#Da der Pfad + Datename bei select-String mit abgespeichert wird, entfernen wir ihn
$body = $body -replace ".*txt:",""

#Leere Zeile zwischen den Fehlermeldungen
#$body = $body -replace ";",";`n`n"
$body.trim() >> tmp2.txt
#---------------------------------------------

#alle mit den Meldungen über nicht unterstützte Vorgänge 
$body = Select-String -path tmp2.txt -pattern 'nicht unterst*' -notmatch  | ForEach-Object {$_.Line}| Foreach {"$_$nl"}| Foreach {"$_$nl"}

#Da der Pfad + Datename bei select-String mit abgespeichert wird, entfernen wir ihn
$body = $body -replace ".*txt:",""

#Leere Zeile zwischen den Fehlermeldungen
#$body = $body -replace ";",";`n`n"
$body.trim() >> tmp3.txt
#---------------------------------------------

#alle mit den Meldungen über den Webserver
#$body = Select-String -path tmp3.txt -pattern 'webserver*' -notmatch  | ForEach-Object {$_.Line}| Foreach {"$_$nl"}

#Da der Pfad + Datename bei select-String mit abgespeichert wird, entfernen wir ihn
#$body = $body -replace ".*txt:",""

#Leere Zeile zwischen den Fehlermeldungen
#$body = $body -replace ";",";`n`n"

#---------------------------------------------


#Überschrift 
$body =  "LOGDATEI: " + $name + " `n" +  "Server: al-sql-04`n" + "Pfad: C:\Program Files\Microsoft SQL Server\MSRS13.MSSQLSERVER\Reporting Services\LogFiles`n" + "---------------------------------------------------------`n" +" `n" +  "FEHLERMELDUNGEN: `n" + " `n" + " `n" + $body 

#Wenn die Überprüfung wahr, dann wird eine Mail vershickt
if( Select-String -path $logdatei -SimpleMatch "error")
{
#SMTP-Server in einer variablen Speichern
$EmailServer = "smtprelay.intern.stimme.de "
#Email verschicken mit angehängter Datei ($logdatei)
Send-MailMessage -to "martin.plewik@stimme.de" -from "PowerShell <report@stimme.de>" -Subject "Auswertung Reportlogdateien" -body "$body" -SmtpServer $EmailServer 
}

#Die Textdateien noch löschen
Remove-Item tmp.txt
Remove-Item tmp1.txt
Remove-Item tmp2.txt
Remove-Item tmp3.txt