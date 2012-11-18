@echo off
cls

call node-inspector -new_console:bn
call dev.cmd --debug-brk

