<?php

require("data.php");

$blocks = explode("\t",$data);

$history = [];
$found = false;
$count = 0;
$wait = false;
$foundWait = false;
$countWait = 0;

while(!$foundWait) {
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
	if($found && !$foundWait) {
		if($current == $wait) {
			$foundWait = true;
		}
	} 
	if(!$found) {
		foreach($history as $item) {
			if($current == $item) {
				$wait = $current;
				$found = true;
			}
		}
	} else {
		$countWait++;
	}
	$count++;
}

echo "Cycles = $countWait\n";
