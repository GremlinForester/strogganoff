rem @echo ================
rem @echo building metal menu...
rem @echo ================
rem cd menu_metal
rem win64-fteqcc.exe -Wno-mundan -srcfile menu.src


@echo ================
@echo building menu...
@echo ================
cd menusys_src
win64-fteqcc.exe -srcfile menu.src