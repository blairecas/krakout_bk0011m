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
echo Compiling MUSIC
echo ===========================================================================
php -f ../scripts/preprocess.php music.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _music.lst _music.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _music.lst _music.bin bin 100000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _music.bin _music_lz.bin

echo.
echo ===========================================================================
echo Compiling CPU
echo ===========================================================================
php -f ../scripts/preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _cpu.lst _cpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _cpu.bin _cpu_lz.bin

echo.
echo ===========================================================================
echo Compiling KRAKOUT
echo ===========================================================================
php -f ../scripts/preprocess.php krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _krakout.lst _krakout.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _krakout.lst ./release/krakout.bin bbk 2000
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/bin2wav.php ./release/krakout.bin
if %ERRORLEVEL% NEQ 0 ( exit /b )

del _cpu.bin
del _cpu_lz.bin
del _music.bin
del _music_lz.bin
del _cpu.mac
del _cpu.lst
del _music.mac
del _music.lst
del _krakout.mac
del _krakout.lst

echo.