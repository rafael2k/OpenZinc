echo off

REM copymak.bat
REM A batch file to copy all of a specific group of make files (i.e. btcpp550.mak)from a user
REM specified base directory to another OpenZinc directory. The first parameter should be 
REM the file name the second parameter should be the base directory 
REM to be executed from the base OpenZinc directory to be copied to

if (%2)==() goto usage

cd source
copy %2\source\%1
cd ..\example\callback\validt
copy %2\example\callback\validt\%1
cd ..\..\data\agency
copy %2\example\data\agency\%1
cd ..\menus
copy %2\example\data\menus\%1
cd ..\notebk
copy %2\example\data\notebk\%1
cd ..\phonbk
copy %2 \example\data\phonbk\%1
cd ..\postwin
copy %2\example\data\postwin\%1
cd ..\spread
copy %2\example\data\spread\%1
cd ..\status
copy %2\example\data\status\%1
cd ..\window
copy %2\example\data\window\%1
cd ..\..\drawitem\analog
copy %2\example\drawitem\analog\%1
cd ..\dsplay
copy %2\example\drawitem\dsplay\%1
cd ..\graph
copy %2\example\drawitem\graph\%1
cd ..\grid
copy %2\example\drawitem\grid\%1
cd ..\lstitm
copy %2\example\drawitem\lstitm\%1
cd ..\..\i18n\delta
copy %2\example\i18n\delta\%1
cd ..\i18n
copy %2\example\drawitem\i18n\%1
cd ..\..\mapping\calc
copy %2\example\mapping\calc\%1
cd ..\calndr
copy %2\example\mapping\calndr\%1
cd ..\palmap
copy %2\example\mapping\palmap\%1
cd ..\..\messages\match
copy %2\example\messages\match\%1
cd ..\mdi
copy %2\example\messages\mdi\%1
cd ..\messgs
copy %2\example\messages\messgs\%1
cd ..\world
copy %2\example\messages\world\%1
cd ..\..\misc\colors
copy %2\example\misc\colors\%1
cd ..\coords
copy %2\example\misc\coords\%1
cd ..\drag
copy %2\example\misc\drag\%1
cd ..\fonts
copy %2\example\misc\fonts\%1
cd ..\frestr
copy %2\example\misc\frestr\%1
cd ..\spy
copy %2\example\misc\spy\%1
cd ..\..\new_obj\browse
copy %2\example\new_obj\browse\%1
cd ..\gmgr
copy %2\example\new_obj\gmgr\%1
cd ..\msgwin
copy %2\example\new_obj\msgwin\%1
cd ..\period
copy %2\example\new_obj\period\%1
cd ..\printer
copy %2\example\new_obj\printer\%1
cd ..\spin
copy %2\example\new_obj\spin\%1
cd ..\table
copy %2\example\new_obj\table\%1
cd ..\..\..\tutor\display
copy %2\tutor\display\%1
cd ..\global
copy %2\tutor\global\%1
cd ..\hello
copy %2\tutor\hello\%1
cd ..\macro
copy %2\tutor\macro\%1
cd ..\movie
copy %2\tutor\movie\%1
cd ..\vlist
copy %2\tutor\vlist\%1
cd ..\word
copy %2\tutor\word\%1
cd ..\zincapp
copy %2\tutor\zincapp\%1
cd ..\..\design
copy %2\design\%1
cd direct
copy %2\design\direct\%1
cd ..\file
copy %2\design\file\%1
cd ..\help
copy %2\design\help\%1
cd ..\i18n
copy %2\design\i18n\%1
cd ..\image
copy %2\design\image\%1
cd ..\message
copy %2\design\message\%1
cd ..\service
copy %2\design\service\%1
cd ..\storage
copy %2\design\storage\%1
cd ..\stredit
copy %2\design\stredit\%1
cd ..\window
copy %2\design\window\%1
cd ..\..

goto done

:usage 
echo: copymak.bat is a batch file to copy all of a specific group of make files
echo: (i.e. btcpp550.mak)from a user specified base OpenZinc directory to another OpenZinc directory.
echo: it requires you to provide two parameters
echo: The first parameter should be the file name
echo: the second parameter should be the base OpenZinc directory
goto done

:done
