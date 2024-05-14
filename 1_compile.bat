@echo off

echo.
echo ===========================================================================
echo Graphics
echo ===========================================================================
..\..\php5\php.exe -f convert_spr.php ./graphics/Tiles.png
..\..\php5\php.exe -f convert_spr.php ./graphics/Sprites.png
..\..\php5\php.exe -f convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling CPU
echo ===========================================================================
..\..\php5\php.exe -f ..\scripts\preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Make packed BIN
echo ===========================================================================
..\..\php5\php.exe -f ..\scripts\lst2bin.php _cpu.lst _cpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _cpu.bin _cpu_lz.bin

rem echo.
rem echo ===========================================================================
rem echo Music and player
rem echo ===========================================================================
rem ..\..\php5\php.exe -f ..\scripts\preprocess.php menumusic.mac
rem if %ERRORLEVEL% NEQ 0 ( exit /b )
rem rem ..\scripts\macro11.exe -ysl 32 -yus -l _menumusic.lst _menumusic.mac
rem if %ERRORLEVEL% NEQ 0 ( exit /b )
rem ..\..\php5\php.exe -f ..\scripts\lst2bin.php _menumusic.lst _menumusic.bin bin 100000
rem ..\scripts\zx0 -f _menumusic.bin _menumusic_lz.bin

echo.
echo ===========================================================================
echo Compiling KRAKOUT
echo ===========================================================================
..\..\php5\php.exe -f ..\scripts\preprocess.php krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -l _krakout.lst _krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Linking KRAKOUT
echo ===========================================================================
..\..\php5\php.exe -f ..\scripts\lst2bin.php _krakout.lst ./release/krakout.bin bbk 2000


echo.