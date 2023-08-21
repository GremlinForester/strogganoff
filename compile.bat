@echo ================
@echo compiling client
@echo ================
cd client
win64-fteqcc.exe -Wno-mundane -srcfile client.src
pause
@echo ================
@echo compiling server
@echo ================
cd ..
fteqcc.exe -Wno-mundane -srcfile progs.src
@echo ================
@echo building new menu...
@echo ================
cd METAL-Lib-main
fteqcc64.exe -Fboundchecks -srcfile menu.src
pause

