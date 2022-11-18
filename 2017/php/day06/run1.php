<?php

require("data.php");

$blocks = explode("\t",$data);

$history = [];
$found = false;
$count = 0;

while(!$found) {
	$history[] = join("\t",$blocks);
	$max = 0;
	foreach($blocks as $block=>$value) {
		if($value > $blocks[$max]) {
			$max = $block;
		}
	}
	$left = $blocks[$max];
	$blocks[$max] = 0;
	while($left > 0) {
		$max++;
		if($max >= sizeof($blocks)) {
			$max = 0;
		}
		$blocks[$max]++;
		$left--;
	}
	$current = join("\t",$blocks);
	foreach($history as $item) {
		if($current == $item) {
			$found = true;
		}
	}
	$count++;
}

echo "Cycles = $count\n";
