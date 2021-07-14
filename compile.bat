@echo ================
@echo building menu...
@echo ================
cd menusys_src
win64-fteqcc.exe -srcfile menu.src
@echo ================
@echo compiling client
@echo ================
cd ..\client
fteqcc.exe -Wno-mundane -srcfile client.src
@echo ================
@echo compiling server
@echo ================
cd ..
fteqcc.exe -Wno-mundane -srcfile progs.src
pause

