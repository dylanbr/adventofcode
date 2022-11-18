<?php

require("data.php");

$lengths = explode(",",$data);
$numbers = range(0,255);

$position = 0;
$skip = 0;
foreach($lengths as $length) {
	$slice = [];
	$count = 0;
	$curr = $position;
	while($count < $length) {
		$slice[] = $numbers[$curr];
		$curr++;
		if($curr > 255) {
			$curr = 0;
		}
		$count++;
	}
	$slice = array_reverse($slice);
	$count = 0;
	$curr = $position;
	while($count < $length) {
		$numbers[$curr] = $slice[$count];
		$curr++;
		if($curr > 255) {
			$curr = 0;
		}
		$count++;
	}
	$position += ($length + $skip);
	if($position > 255) {
		$position = $position % 256;
	}
	$skip++;
}
echo "Product of first two numbers = " . ($numbers[0] * $numbers[1]) . "\n";
