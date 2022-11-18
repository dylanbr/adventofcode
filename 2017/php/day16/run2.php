<?php

require("data.php");

$steps = explode(",",$data);
foreach($steps as &$step) {
	$step = [
		'op'=>$step[0],
		'params'=>array_pad(explode("/",substr($step,1)),2,0)
	];
}
unset($step);

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

$extra = false;
$c=0;
while($extra === false || $extra > 0) {
	foreach($steps as $step) {
		$p0 = $step['params'][0];
		$p1 = $step['params'][1];
		switch($step['op']) {
		case "s":
			$positions = rotate($positions,$p0);
			break;
		case "x":
			$temp = $positions[$p0];
			$positions[$p0] = $positions[$p1];
			$positions[$p1] = $temp;
			break;
		case "p":
			$names = array_flip($positions);
			$temp = $positions[$names[$p0]];
			$positions[$names[$p0]] = $positions[$names[$p1]];
			$positions[$names[$p1]] = $temp;
			break;
		}
	}
	$c++;
	if($extra !== false) {
		$extra--;
	}
	if(join("",$positions) == "abcdefghijklmnop") {
		$extra = 1000000000 % $c;
	}
}

echo "Order = " . join("",$positions) . "\n";
