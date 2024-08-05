@echo off
REM SMAKE.BAT - for Zinc Application Framework 4.1
REM This batch file can be used to compile all tutorial programs supplied.

if (%1)==() goto usage
goto spawn1

:usage
echo ...........
echo ...........
echo To make the Zinc examples for Borland C++ type:
echo make -fbtcpp450.mak dos
echo make -fbtcpp450.mak dos16
echo make -fbtcpp450.mak dos32
echo make -fbtcpp450.mak windows
echo make -f btcpp450.mak winnt
echo make -fbtcpp200.mak os2
echo ...........
echo To generate this Zinc tutorial for IBM C++ type:
echo nmake -f iccpp210.mak os2
echo nmake -f iccpp300.mak os2
echo ...........
echo To make the Zinc examples for Visual C++ type:
echo nmake -fmvcpp150.mak dos
echo nmake -fmvcpp150.mak dos16
echo nmake -fmvcpp100.mak dos32
echo nmake -fmvcpp150.mak windows
echo nmake -f mvcpp200.mak winnt
echo ...........
echo To make the Zinc examples for Symantec C++ type:
echo smake -fsccpp700.mak dos
echo smake -fsccpp700.mak dos32
echo smake -fsccpp700.mak windows
echo ...........
echo To make the Zinc examples for Watcom C++ type:
echo wmake -fwccpp105.mak dos32
echo wmake -fwccpp105.mak windows
echo wmake -f wccpp105.mak winnt
echo wmake -fwccpp105.mak os2
echo ...........
echo ...........
goto done

:spawn1
if (%2)==(clean) goto spawn2
goto spawn3
:spawn2
@call z_clean.bat
:spawn3
cd hello
smake %1 %2 %3 %4 %5
cd ..
cd word
smake %1 %2 %3 %4 %5
cd ..
cd zincapp
smake %1 %2 %3 %4 %5
cd ..
cd macro
smake %1 %2 %3 %4 %5
cd ..
cd display
smake %1 %2 %3 %4 %5
cd ..
cd vlist
smake %1 %2 %3 %4 %5
cd ..
cd global
smake %1 %2 %3 %4 %5
cd ..
cd movie
smake %1 %2 %3 %4 %5
cd ..

:done
