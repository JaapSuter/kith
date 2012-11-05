@echo off
cls
foreman start -f=Procfile-dev -e=.env-dev

