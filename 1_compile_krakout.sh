#!/bin/sh

echo ===========================================================================
echo Graphics
echo ===========================================================================
php -f convert_spr.php ./graphics/Tiles.png
[ $? -eq 0 ] || exit 1
php -f convert_spr.php ./graphics/Sprites.png
[ $? -eq 0 ] || exit 1
php -f convert_font.php
[ $? -eq 0 ] || exit 1

echo ===========================================================================
echo Compiling MUSIC
echo ===========================================================================
php -f ../scripts/preprocess.php music.mac
[ $? -eq 0 ] || exit 1
../scripts/macro11 -ysl 32 -yus -l _music.lst _music.mac
[ $? -eq 0 ] || exit 1
php -f ../scripts/lst2bin.php _music.lst _music.bin bin 100000
[ $? -eq 0 ] || exit 1
../scripts/zx0 -f _music.bin _music_lz.bin
[ $? -eq 0 ] || exit 1

echo ===========================================================================
echo Compiling CPU
echo ===========================================================================
php -f ../scripts/preprocess.php cpu.mac
[ $? -eq 0 ] || exit 1
../scripts/macro11 -ysl 32 -yus -l _cpu.lst _cpu.mac
[ $? -eq 0 ] || exit 1
php -f ../scripts/lst2bin.php _cpu.lst _cpu.bin bin 1000
[ $? -eq 0 ] || exit 1
../scripts/zx0 -f _cpu.bin _cpu_lz.bin
[ $? -eq 0 ] || exit 1

echo ===========================================================================
echo Compiling KRAKOUT
echo ===========================================================================
php -f ../scripts/preprocess.php krakout.mac
[ $? -eq 0 ] || exit 1
../scripts/macro11 -ysl 32 -yus -l _krakout.lst _krakout.mac
[ $? -eq 0 ] || exit 1
php -f ../scripts/lst2bin.php _krakout.lst ./release/krakout.bin bbk 2000
[ $? -eq 0 ] || exit 1
