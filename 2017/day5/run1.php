<?php

require("data.php");

$jumps = explode("\n",$data);

$pos = 0;
$steps = 0;
while($pos > -1 && $pos < sizeof($jumps)) {
	$last = $pos;
	$pos += $jumps[$pos];
	$jumps[$last]++;
	$steps++;
}

echo "Steps = $steps\n";
