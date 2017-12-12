<?php

require("data.php");

$len = strlen($data);
$halfLen = $len / 2;
$total = 0;
for($x = 0; $x < $len; $x++) {
	$half = $x + $halfLen;
	if($half > $len) {
		$half -= $len;
	}
	if($data[$x] === $data[$half]) {
		$total += $data[$x];
	}
}
echo "Total = $total\n";
