echo off
echo Enter the base directory for you Borland C++ installation
echo for example:  c:\bc45    Press  F6 then ENTER when done
COPY CON bcdir.tmp
CLS
echo you typed
type bcdir.tmp + \bin 
pause

