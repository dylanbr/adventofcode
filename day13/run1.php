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

$myLayer = 0;
$severity = 0;
while($myLayer < $max) {
	foreach($states as $layer=>&$state) {
		if($state['scanner']) {
			if($layer == $myLayer && $state['position'] == 1) {
				$severity += ($layer * $state['depth']);
			}
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
	$myLayer++;
}

echo "Severity of whole trip = $severity\n";
