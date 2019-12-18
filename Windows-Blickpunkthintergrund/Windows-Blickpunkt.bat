@ECHO OFF

mkdir C:\Users\%USERNAME%\Pictures\Hintergrund-Blickpunkt

copy C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*.*  C:\Users\%USERNAME%\Pictures\Hintergrund-Blickpunkt\

cd C:\Users\%USERNAME%\Pictures\Hintergrund-Blickpunkt

ren *.** *.jpg





