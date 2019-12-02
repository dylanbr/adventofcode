<?php

require("data.php");

$level = 0;
$garbage = false;
$comment = false;
$total = 0;
$totalComment = 0;
for($c=0; $c<strlen($data); $c++) {
	$char = $data[$c];

	if(!$garbage) {
		if($char == "{") $level++;
		if($char == "}") {
			$total += $level;
			$level--;
		}	
		if($char == "<") $garbage = true;
	} else {
		if(!$comment) {
			if($char == ">") {
				$garbage = false;
			} else if($char == "!") {
				$comment = true;
			} else {
				$totalComment++;
			}
		} else {
			$comment = false;
			continue;
		}
	}
}
echo "Non-canceled characters within garbage = $totalComment\n";
