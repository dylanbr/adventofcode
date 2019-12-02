<?php

define("UP",1);
define("RIGHT",2);
define("DOWN",3);
define("LEFT",4);

require("data.php");

$iterations = 10000000;
/*
$iterations = 100;
//*/

/*
$data = "..#
#..
...";
//*/

$rawMap = explode("\n",$data);
$map = [];
$reduce = floor(sizeof($rawMap)/2);
foreach($rawMap as $rowKey=>$row) {
	$rawCols = str_split($row);
	$cols = [];
	foreach($rawCols as $colKey=>$col) {
		$cols[$colKey-$reduce] = $col;
	}
	$map[$rowKey-$reduce] = $cols;
}

function move($direction,$x,$y) {
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
	return [$x,$y];
}

$x = 0;
$y = 0;
$direction = UP;
$infections = 0;
for($c=0;$c<$iterations;$c++) {
	$node =& $map[$y][$x];
	switch($node) {
	default:
	case ".":
		$node = "W";
		$direction--;
		if($direction < UP) {
			$direction = LEFT;
		}
		break;
	case "W":
		$node = "#";
		$infections++;
		break;
	case "#":
		$node = "F";
		$direction++;
		if($direction > LEFT) {
			$direction = UP;
		}
		break;
	case "F":
		$node = ".";
		if($direction > RIGHT) {
			$direction -= 2;
		} else {
			$direction += 2;
		}
		break;
	}

	list($x,$y) = move($direction,$x,$y);
	echo "Iteration = " . ($c + 1) . " of $iterations\r";
}
echo "\n";

echo "Infections = $infections\n";


