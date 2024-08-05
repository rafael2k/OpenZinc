@echo off
SET D16M=d:\dos16m\bin
splice %1 %D16M%\mouse33.exp %D16M%\emu87.exp %D16M%\int10.exp %1
set D16M=
