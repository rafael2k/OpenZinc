@echo off
REM DSNALL.BAT - for OpenZinc Application Framework 
REM This batch file will execute a set of commands in all design directories.

if NOT (%1)==() goto dsnall
echo: DSNALL will execute a set of commands in all design directories.
echo:  for example DSNALL copy abc200.mak abc300.mak
echo:  will execute "copy abc200.mak abc300.mak" in design root directory
echo:  and all design subdirectories
goto done

:dsnall
%1 %2 %3 %4 %5
cd direct
%1 %2 %3 %4 %5
cd ..\file
%1 %2 %3 %4 %5
cd ..\help
%1 %2 %3 %4 %5
cd ..\i18n
%1 %2 %3 %4 %5
cd ..\image
%1 %2 %3 %4 %5
cd ..\message
%1 %2 %3 %4 %5
cd ..\service
%1 %2 %3 %4 %5
cd ..\storage
%1 %2 %3 %4 %5
cd ..\stredit
%1 %2 %3 %4 %5
cd ..\window
%1 %2 %3 %4 %5
cd ..
:done
