@echo ================
@echo building metal menu...
@echo ================
cd menu_metal
win64-fteqcc.exe -Wno-mundan -srcfile menu.src
