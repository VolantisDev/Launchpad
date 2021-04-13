: Add version info resource with some strings and a help text resource file to verpatch.exe
: Run this in the directory where verpatch.exe is built, either Release or Debug
: (this serves also as a self test)
:
set _ver="1.0.15.1 [%date%]"
set _s1=/s desc "PE version patcher tool" 
set _s1=%_s1% /s copyright "(C) 1998-2016, pavel_a"
set _s1=%_s1% /pv "1.0.0.1-Codeplex" 
: test leading zeros-  set _s1=%_s1% /s productversion "1.000.00.001-Codeplex" 
set _s2=/s private "%USERNAME%@%USERDOMAIN%"

: Note: 64 is the resource ID of help text, it is hardcoded in the program
set _resfile=/rf #64 "%~dp0\usage.txt"

: Run a copy of verpatch on itself:

copy verpatch.exe v.exe || exit /b 1

v.exe verpatch.exe /va %_ver% %_s1% %_s2% %_resfile% 

@echo Errorlevel=%errorlevel%

@rem del v.exe
