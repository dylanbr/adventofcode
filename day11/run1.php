<?php

define(X,0);
define(Y,1);
define(Z,2);

require("data.php");

$steps = explode(",",$data);

// Ref: https://www.redblobgames.com/grids/hexagons/
function tocube($c, $r) {
	$x = $c;
	$z = $r;
	$y = -$x-$z;
	return [$x,$y,$z];
}

function distance($cube) {
	$origin = [0,0,0];
	return (abs($origin[X] - $cube[X]) + abs($origin[Y] - $cube[Y]) + abs($origin[Z] - $cube[Z])) / 2;
}

$y = 0;
$x = 0;
foreach($steps as $step) {
	if($step == "n") $y--;
	if($step == "s") $y++;
	if($step == "nw") { $x--; }
	if($step == "ne") { $x++; $y--; }
	if($step == "sw") { $x--; $y++; }
	if($step == "se") { $x++; }
}
echo "Steps to child process = " . distance(tocube($x,$y)) . "\n";
