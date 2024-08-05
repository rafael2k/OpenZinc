@echo off
REM MAKEALL.CMD - for Zinc Application Framework 4.1
REM This batch file can be used to compile all example programs supplied.

if NOT (%1)==() goto makeall
echo: MAKEALL will make all example programs supplied.
echo:  Borland C++:          MAKEALL make -fbtcpp450.mak {dos, dos16, dos32, windows, winnt}
echo:                        MAKEALL make -fbtcpp200.mak os2
echo:  IBM C++:              MAKEALL nmake -f iccpp210.mak os2
echo:  IBM VisualAge C++:    MAKEALL nmake -f iccpp300.mak os2
echo:  Microsoft Visual C++: MAKEALL nmake -fmvcpp150.mak {dos, dos16, windows}
echo:                        MAKEALL nmake -fmvcpp100.mak dos32
echo:                        MAKEALL nmake -fmvcpp200.mak winnt
echo:  Symantec C++:         MAKEALL smake -fsccpp600.mak {dos, dos32, windows}
echo:  Watcom C++:           MAKEALL wmake -fwccpp105.mak {dos32, windows, winnt, os2}
goto done

:makeall
FOR %%I IN (validt) DO                               call domake callback\%%I %1 %2 %3 %4 %5
FOR %%I IN (agency menus notebk phonbk postwn spread status window) DO call domake data\%%I %1 %2 %3 %4 %5
FOR %%I IN (analog dsplay graph grid lstitm) DO      call domake drawitem\%%I %1 %2 %3 %4 %5
FOR %%I IN (delta i18n) DO                           call domake i18n\%%I %1 %2 %3 %4 %5
FOR %%I IN (calc calndr palmap) DO                   call domake mapping\%%I %1 %2 %3 %4 %5
FOR %%I IN (match mdi messgs world) DO               call domake messages\%%I %1 %2 %3 %4 %5
FOR %%I IN (gmgr msgwin period printr spin table) DO call domake new_obj\%%I %1 %2 %3 %4 %5
FOR %%I IN (colors coords drag fonts frestr spy) DO  call domake misc\%%I %1 %2 %3 %4 %5
:done
