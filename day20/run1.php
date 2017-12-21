<?php

require("data.php");

define("X",0);
define("Y",1);
define("Z",2);

function distance($position) {
	return abs($position[X]) + abs($position[Y]) + abs($position[Z]);
}

$particles = array_map(function($line) {
	preg_match_all("/-?\d+/",$line,$matches);
	$particle =  [
		'position'=>array_slice($matches[0],0,3),
		'velocity'=>array_slice($matches[0],3,3),
		'accelleration'=>array_slice($matches[0],6,3)
	];
	$particle['distance'] = distance($particle['position']);
	return $particle;
},explode("\n",$data));
echo "Found " . sizeof($particles) . " particles\n";

function update() {
	global $particles;

	$closest = false;
	$closestKey = false;
	foreach($particles as $key=>&$particle) {
		$particle['velocity'][X] += $particle['accelleration'][X];
		$particle['velocity'][Y] += $particle['accelleration'][Y];
		$particle['velocity'][Z] += $particle['accelleration'][Z];
		$particle['position'][X] += $particle['velocity'][X];
		$particle['position'][Y] += $particle['velocity'][Y];
		$particle['position'][Z] += $particle['velocity'][Z];
		$particle['distance'] = distance($particle['position']);
		if($closest == false || $particle['distance'] < $closest) {
			$closest = $particle['distance'];
			$closestKey = $key;
		}
	}
	unset($particle);
	return ['distance'=>$closest, 'key'=>$closestKey];
}

$last = false;
$stable = 0;
while($stable < 1000) {
	$closest = update();
	echo "Closest particle is #$closest[key] at a distance of $closest[distance]\r";
	if($last != false && $closest['key'] == $last) {
		$stable++;
	} else {
		$last = $closest['key'];
		$stable = 0;
	}
}
echo "\n";
