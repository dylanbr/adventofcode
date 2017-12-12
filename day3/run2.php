<?php

require("data.php");

define("RIGHT", 1);
define("UP", 2);
define("LEFT", 3);
define("DOWN", 4);
define("X", 0);
define("Y", 1);

define("X", 0);
define("Y", 1);

$rules = [
	RIGHT => ['op'=>"+", 'var'=>"x"],
	UP    => ['op'=>"-", 'var'=>"y"],
	LEFT  => ['op'=>"-", 'var'=>"x"],
	DOWN  => ['op'=>"+", 'var'=>"y"]
];

$compare = ['+'=>">",'-'=>"<"];

$edges = [
	'-' => ['x'=>0, 'y'=>0],
	'+' => ['x'=>0, 'y'=>0]
];

$adjs = [
	['x'=>-1, 'y'=>0],
	['x'=>-1, 'y'=>-1],
	['x'=> 0, 'y'=>-1],
	['x'=> 1, 'y'=>-1],
	['x'=> 1, 'y'=> 0],
	['x'=> 1, 'y'=> 1],
	['x'=> 0, 'y'=> 1],
	['x'=>-1, 'y'=> 1]
];

$target = $_SERVER['argv'][1]?:$data;
echo "Target = $target\n";

$x=0;
$y=0;
$direction = RIGHT;
$grid = [];
$sum = 0;

while($sum < $target) {
	if(!array_key_exists($x,$grid)) {
		$grid[$x] = [];
	}
	$sum = 0;
	foreach($adjs as $adj) {
		$aX = $x + $adj['x'];
		$aY = $y + $adj['y'];
		if(isset($grid[$aX][$aY])) {
			$sum += $grid[$aX][$aY];
		}
	}
	if($sum == 0) {
		$sum = 1;
	}
	$grid[$x][$y] = $sum;

	$rule = $rules[$direction];
	$op = $rule['op'];
	$var = $rule['var'];
	$edge = '$edges[$op][$var]';
	eval("$$var$op$op;");
	eval("
		if($$var ${compare[$op]} $edge) { 
			$edge = $$var;
			\$direction++;
		}
	");
	if($direction > 4) {
		$direction = 1;
	}
}

echo "Sum = $sum\n";
