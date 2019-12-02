<?php

require("data.php");

define("DOWN",1);
define("UP",2);

$lines = explode("\n",$data);
$scanners = [];
foreach($lines as $line) {
	list($scanner,$range) = explode(": ",$line);
	$scanners[$scanner] = $range;
}

$states = [];
$max = max(array_keys($scanners))+1;
for($c=0; $c<$max; $c++) {
	if(array_key_exists($c, $scanners)) {
		$states[$c] = [
			'scanner'=>true,
			'depth'=>$scanners[$c],
			'position'=>1,
			'direction'=>DOWN
		];
	} else {
		$states[$c] = [
			'scanner'=>false
		];
	}
}

function run(&$states) {
	foreach($states as &$state) {
		if($state['scanner']) {
			if($state['direction'] == DOWN) {
				$state['position']++;
				if($state['position'] == $state['depth']) {
					$state['direction'] = UP;
				}
			} else {
				$state['position']--;
				if($state['position'] == 1) {
					$state['direction'] = DOWN;
				}
			}
		}
	}
	unset($state);
}

$delay = 0;
$caught = true;
while($caught) {
	$delayedStates = $states;
	$myLayer = 0;
	$caught = false;
	while($myLayer < $max) {
		foreach($delayedStates as $layer=>$state) {
			if($state['scanner'] && $layer == $myLayer && $state['position'] == 1) {
				$caught = true;
				break;
			}
		}
		if($caught) {
			break;
		}
		run($delayedStates);
		$myLayer++;
	}
	run($states);
	$delay++;
	echo "Delay progress = $delay\r";
}
$delay--;
echo "Delay required to avoid being caught = $delay\n";
