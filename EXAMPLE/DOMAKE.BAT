@echo off
rem Make in one directory.
cd %1

if (%2)==(zap) goto dozap
%2 %3 %4 %5 %6
goto done

:dozap
del b16.def
del b16m.def
del b16pp.def
del makefile
del m16.def
del os2.ico
del os2.rc
del windows.def
del windows.ico
del windows.rc
del bccpp100.mak
del bccpp150.mak
del bccpp200.mak
del btcpp310.mak
del btcpp400.mak
del btcpp450.mak
del iccpp200.mak
del iccpp210.mak
del makefile.nxt
del mscpp800.mak
del mvcpp100.mak
del mvcpp150.mak
del mvcpp200.mak
del posix.mak
del sccpp600.mak
del sccpp610.mak
del wccpp105.mak
del os2.def
:done

cd ..\..
