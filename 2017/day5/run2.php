<?php

require("data.php");

$jumps = explode("\n",$data);

$pos = 0;
$steps = 0;
while($pos > -1 && $pos < sizeof($jumps)) {
	$last = $pos;
	$pos += $jumps[$pos];
	if($jumps[$last] >= 3) {
		$jumps[$last]--;
	} else {
		$jumps[$last]++;
	}
	$steps++;
}

echo "Steps = $steps\n";
