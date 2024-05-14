<?php
    $fname = $argv[1];
    $fname_part = pathinfo($fname, PATHINFO_FILENAME);

    $img = imagecreatefrompng($argv[1]);
    $width = imagesx($img);
    $height = imagesy($img);
    echo "Image: $width x $height\n";
    $tiles_dx = intval($width / 16);
    $tiles_dy = intval($height / 16);
    echo "Tiles: $tiles_dx x $tiles_dy\n";
    
    // images array
    $tilesArray = Array();
    $haveDataArray = Array();
    $namesArray = Array();
    $firstLinesArray = Array();
    $lastLinesArray = Array();

    $cur_tile = 0;
    $last_tile = 0;
    
    // scan image and create array
    for ($tiley=0; $tiley<$tiles_dy; $tiley++)
    {
        for ($tilex=0; $tilex<$tiles_dx; $tilex++)
        {
	        $tile = Array();
            $have_data = false;
            $first_not_empty = 0;
            $last_not_empty = 0;
	        for ($y=0; $y<16; $y++)
            {
                $empty_line = false;
                // first word
                $res1 = 0; 
		        for ($x=0; $x<8; $x++)
                {
                    $py = $tiley*16 + $y;
		            $px = $tilex*16 + $x;
		            $res1 = ($res1 >> 2) & 0xFFFF;
                    $rgb_index = imagecolorat($img, $px, $py);
                    $rgba = imagecolorsforindex($img, $rgb_index);
                    $r = $rgba['red'];
                    $g = $rgba['green'];
                    $b = $rgba['blue'];
                    // blue pixel
                    if ($b > 127) $res1 = $res1 | 0b0100000000000000;
                    // green pixel
                    if ($g > 127) $res1 = $res1 | 0b1000000000000000;
                    // red pixel
                    if ($r > 127) $res1 = $res1 | 0b1100000000000000;
                }
                // second word
                $res2 = 0; 
		        for ($x=8; $x<16; $x++)
                {
                    $py = $tiley*16 + $y;
		            $px = $tilex*16 + $x;
		            $res2 = ($res2 >> 2) & 0xFFFF;
                    $rgb_index = imagecolorat($img, $px, $py);
                    $rgba = imagecolorsforindex($img, $rgb_index);
                    $r = $rgba['red'];
                    $g = $rgba['green'];
                    $b = $rgba['blue'];
                    // blue pixel
                    if ($b > 127) $res2 = $res2 | 0b0100000000000000;
                    // green pixel
                    if ($g > 127) $res2 = $res2 | 0b1000000000000000;
                    // red pixel
                    if ($r > 127) $res2 = $res2 | 0b1100000000000000;
                }
                // empty line?
                if ($res1 == 0 && $res2 == 0) $empty_line = true;
                if (!$empty_line) {
                    $have_data = true;
                    if ($first_not_empty == 0) $first_not_empty = $y;
                    $last_not_empty = $y;
                } 
                array_push($tile, $res1);
                array_push($tile, $res2);
            }
	        array_push($tilesArray, $tile);
            array_push($haveDataArray, $have_data);
            array_push($firstLinesArray, $first_not_empty);
            array_push($lastLinesArray, $last_not_empty);
            // create name
            $name = $fname_part . str_pad("".$cur_tile, 3, "0", STR_PAD_LEFT);
            array_push($namesArray, $name);
            //
            $cur_tile++;
            if ($have_data) $last_tile = $cur_tile;
        }
    }
    
    echo "Images count: ".$last_tile."\n";
    
    ////////////////////////////////////////////////////////////////////////////
    // Output
    ////////////////////////////////////////////////////////////////////////////

    echo "Writing CPU images data ".$fname_part." ...\n";    
    $f = fopen ("inc_cpu_".strtolower($fname_part).".mac", "w");

    $is_sprites = false;
    if (strtolower($fname_part) == "sprites") $is_sprites = true;

    // Names table (if needed)
    if ($is_sprites) 
    {
        fputs($f, $fname_part."Table:\n");
        for ($t=0, $n=0; $t<$last_tile; $t++)
        {
            if ($n==0) fputs($f, "\t.word\t");
            if ($haveDataArray[$t]) {
                fputs($f, $namesArray[$t]);
            } else {
                fputs($f, "0");
            }
            $n++; if ($n<10 && ($t<$last_tile-1)) fputs($f, ", "); else { $n=0; fputs($f, "\n"); }
        }
        fputs($f, "\n".$fname_part."TableEnd:\n");
    }

    // Data
    fputs($f, $fname_part."Data:\n");
    for ($t=0; $t<$last_tile; $t++)
    {
        $start_data = 0;
        $end_data = 16*2;
        if ($is_sprites) {
            if (!$haveDataArray[$t]) continue;
            fputs($f, $namesArray[$t].":\n");
            fputs($f, "\t.byte\t".decoct($firstLinesArray[$t]).", ".decoct($lastLinesArray[$t]-$firstLinesArray[$t]+1)."\n");
            $start_data = $firstLinesArray[$t]*2;
            $end_data = ($lastLinesArray[$t]+1)*2;
        }
	    $tile = $tilesArray[$t];
	    for ($i=$start_data, $n=0; $i<$end_data; $i++)
	    {
	        if ($n==0) fputs($f, "\t.word\t");
	        $ww = $tile[$i];
	        fputs($f, decoct($ww));
	        $n++; if ($n<8 && $i<($end_data-1)) fputs($f, ", "); else { $n=0; fputs($f, "\n"); }
	    }
        fputs($f, "\n");
    }
    fputs($f, "\n");
    fclose($f);

?>