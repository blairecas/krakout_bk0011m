@echo off

echo.
echo ===========================================================================
echo Graphics
echo ===========================================================================
php -f convert_spr.php ./graphics/Tiles.png
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f convert_spr.php ./graphics/Sprites.png
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling CPU
echo ===========================================================================
php -f ..\scripts\preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ..\scripts\lst2bin.php _cpu.lst _cpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _cpu.bin _cpu_lz.bin

echo.
echo ===========================================================================
echo Compiling KRAKOUT
echo ===========================================================================
php -f ..\scripts\preprocess.php krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -l _krakout.lst _krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ..\scripts\lst2bin.php _krakout.lst ./release/krakout.bin bbk 2000


echo.