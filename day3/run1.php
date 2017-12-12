<?php

require("data.php");

define("RIGHT", 1);
define("UP", 2);
define("LEFT", 3);
define("DOWN", 4);

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

$target = $_SERVER['argv'][1]?:$data;
echo "Target = $target\n";

$x=0;
$y=0;
$direction = RIGHT;

for($count = 1; $count < $target; $count++) {
	$rule = $rules[$direction];
	$op = $rule['op'];
	$var = $rule['var'];
	$edge = '$edges[$op][$var]';
	eval("$$var$op$op;");
	eval("if($$var ${compare[$op]} $edge) { $edge = $$var; \$direction++;}");
	if($direction > 4) {
		$direction = 1;
	}
}

echo "Steps = " . (abs($x) + abs($y)) . "\n";

