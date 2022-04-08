rem @echo ================
rem @echo building menu...
rem @echo ================
rem cd menusys_src
rem win64-fteqcc.exe -srcfile menu.src

@echo ================
@echo building metal menu...
@echo ================
cd menu_metal
win64-fteqcc.exe -Wno-mundan -srcfile menu.src


@echo ================
@echo compiling client
@echo ================
cd ..\client
win64-fteqcc.exe -Wno-mundane -srcfile client.src
@echo ================
@echo compiling server
@echo ================
cd ..
fteqcc.exe -Wno-mundane -srcfile progs.src
pause

