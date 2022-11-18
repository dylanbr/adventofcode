<?php

require("data.php");

$steps = explode(",",$data);

$positions = [];
for($c=0; $c<16; $c++) {
	$positions[$c] = chr(ord('a')+$c);
}

function rotate($arr,$steps) {
	for($c=0;$c<$steps;$c++) {
		array_unshift($arr,array_pop($arr));
	}
	return $arr;
}

foreach($steps as $step) {
	$op = $step[0];
	$params = explode("/",substr($step,1));
	switch($op) {
	case "s":
		$positions = rotate($positions,$params[0]);
		break;
	case "x":
		$temp = $positions[$params[0]];
		$positions[$params[0]] = $positions[$params[1]];
		$positions[$params[1]] = $temp;
		break;
	case "p":
		$names = array_flip($positions);
		$temp = $positions[$names[$params[0]]];
		$positions[$names[$params[0]]] = $positions[$names[$params[1]]];
		$positions[$names[$params[1]]] = $temp;
		break;
	}
}

echo "Order = " . join("",$positions) . "\n";
