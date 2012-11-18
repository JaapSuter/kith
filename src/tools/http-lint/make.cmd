@echo off
cls

echo ----
echo NOTE: This makefile is an ugly piece of slapped
echo together hack work that'll probably only work
echo on one specific windows machine on one specific
echo Gregorian calender day. All I ever wanted was
echo a Windows binary... :-)
echo ----


call "%ProgramFiles(x86)%\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
copy %~dp0src\*.dll %~dp0bin\.
cd src
cl /MT /wd4047 /I%~dp0src http-lint.c libcurl_imp.lib boost_regex-vc100-mt-1_51.lib /Fe..\bin\http-lint.exe
cd %~dp0


