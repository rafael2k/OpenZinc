@echo off
if "%1" == "oem" goto start
if "%1" == "iso" goto start
goto error
:start
ren %1_dial.chr trip.chr
ren %1_syst.chr sans.chr
ren %1_smal.chr litt.chr
fe
ren trip.chr %1_dial.chr
ren sans.chr %1_syst.chr
ren litt.chr %1_smal.chr
goto end
:error
echo usage: edit [oem, iso]
:end
