<?php

require("data.php");

define("UP",1);
define("RIGHT",2);
define("DOWN",3);
define("LEFT",4);

$lines = explode("\n",$data);
array_shift($lines);
$map = array_map(function($line) {
	return str_split($line);
},$lines);
$maxX = sizeof($map[0])-1;
$maxY = sizeof($map)-1;

function step($x, $y, $direction) {
	switch($direction) {
	case UP:
		$y--;
		break;
	case DOWN:
		$y++;
		break;
	case LEFT:
		$x--;
		break;
	case RIGHT:
		$x++;
		break;
	}
	return [$x, $y];
}

$x = array_search("|",$map[0]);
$y = 0;
$direction = DOWN;
$found = "";
while(true) {
	list($newX, $newY) = step($x, $y, $direction);
	if($map[$y][$x] == "+" && $map[$newY][$newX] == " ") {
		foreach([-1,1] as $turn) {
			$attempt = $direction + $turn;
			if($attempt < UP) { $attempt = LEFT; }
			if($attempt > LEFT) { $attempt = UP; }
			list($newX, $newY) = step($x, $y, $attempt);
			if($map[$newY][$newX] != " ") {
				$direction = $attempt;
				break;
			}
		}	
	}
	$x = $newX;
	$y = $newY;
	if($x < 0 || $x >= $maxX || $y < 0 || $y >= $maxY || $map[$y][$x] == " ") {
		break;
	}
	$char = $map[$y][$x];
	if($char >= 'A' && $char <= 'Z') {
		$found .= $char;
	}
}
echo "Found = $found\n";
