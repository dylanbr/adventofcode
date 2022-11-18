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

function collide() {
	global $particles;
	$remove = [];
	foreach($particles as $key1=>$particle1) {
		foreach($particles as $key2=>$particle2) {
			if($key1 == $key2) continue;
			if(
				$particle1['position'][X] == $particle2['position'][X]
				&& $particle1['position'][Y] == $particle2['position'][Y]
				&& $particle1['position'][Z] == $particle2['position'][Z]
			) {
				$remove[] = $key1;
				$remove[] = $key2;
			}
		}
	}
	$remove = array_unique($remove);
	$new = [];
	foreach($particles as $key=>$particle) {
		if(!in_array($key, $remove)) {
			$new[] = $particle;
		}
	}
	$particles = $new;
}

$last = false;
$stable = 0;
while($stable < 100) {
	$closest = update();
	collide();
	$count = sizeof($particles);
	echo "Particles count = " . $count . "     \r";
	if($last != false && $count == $last) {
		$stable++;
	} else {
		$last = $count;
		$stable = 0;
	}
}
echo "\n";
