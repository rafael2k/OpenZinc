echo off

REM newmak.bat
REM A batch file to copy all of a specific group of make files (i.e. btcpp550.mak)
REM to a set of make files with a different name (i.e. new.mak). The first parameter should be 
REM the file name to be copied the second parameter should be the name of the new  
REM set of make files. This is useful as a starting point for a new version of an 
REM existing compiler. Execute from base OpenZinc directory

if (%2)==() goto usage

cd source 
copy %1 %2
cd gfx\source
copy %1 %2
cd ..\..\..\example
call makeall copy %1 %2
cd ..\tutor
call makeall copy %1 %2
cd ..\design
call dsnall copy %1 %2
cd ..
goto done

:usage
echo: newmak.bat is a batch file
echo: to copy all of a specific group of make files (i.e. btcpp550.mak)
echo: to a set of make files with a different name (i.e. new.mak). The first parameter should be 
echo: the file name to be copied the second parameter should be the name of the new  
echo: set of make files. This is useful as a starting point for a new version of an 
echo: existing compiler. Execute from base OpenZinc directory
goto done

:done