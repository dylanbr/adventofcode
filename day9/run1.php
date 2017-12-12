<?php

require("data.php");

$level = 0;
$garbage = false;
$comment = false;
$total = 0;
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
			if($char == ">") $garbage = false;
			if($char == "!") $comment = true;
		} else {
			$comment = false;
			continue;
		}
	}
}
echo "Total score = $total\n";
