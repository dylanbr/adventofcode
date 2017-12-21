<?php

require("data.php");
$iterations = 5;

/*
$data = "../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#";
$iterations = 2;
//*/

$rules = array_map(function($rule) {
	list($from, $to) = explode(" => ", $rule);
	$from = array_map(function($row) {
		return str_split($row);
	},explode("/",$from));
	$to = array_map(function($row) {
		return str_split($row);
	},explode("/", $to));
	return [
		'from'=>$from,
		'to'=>$to
	];
},explode("\n",$data));

$grid = [
	['.', '#', '.'],
	['.', '.', '#'],
	['#', '#', '#']
];

function flip($start, $flip) {
	if(empty($flip)) return $start;

	$result = [];
	foreach($start as $row) {
		array_unshift($result, $row);
	}
	return $result;
}

function rotate($start, $rotate) {
	if(empty($rotate)) return $start;

	$size = sizeof($start);
	$result = $start;
	for($c=0;$c<$rotate;$c++) {
		$new = [];
		foreach($result as $rowKey=>$row) {
			foreach($row as $colKey=>$col) {
				$new[$size-$colKey-1][$rowKey] = $result[$rowKey][$colKey];
			}
		}
		$result = $new;
	}
	return $result;
}

function create_transforms() {
	$transforms = [];

	for($size=2; $size<=3; $size++) {
		$start = [];
		for($y=0;$y<$size;$y++) {
			for($x=0;$x<$size;$x++) {
				$start[$y][$x] = [$y,$x];
			}
		}
		for($flip=0;$flip<=1;$flip++) {
			$flipped = flip($start,$flip);
			for($rotate=0;$rotate<=3;$rotate++) {
				$transforms[] = rotate($flipped, $rotate);
			}
		}
	}
	return $transforms;
}
$transforms = create_transforms();

function match($grid1, $grid2) {
	foreach($grid1 as $rowKey=>$row) {
		foreach($row as $colKey=>$col) {
			if($grid1[$rowKey][$colKey] != $grid2[$rowKey][$colKey]) {
				return false;
			}
		}
	}
	return true;
}

function apply_transform($grid, $transform) {
	$newGrid = [];
	$size = sizeof($grid);
	for($y=0;$y<$size;$y++) {
		for($x=0;$x<$size;$x++) {
			list($transformX, $transformY) = $transform[$y][$x];
			$newGrid[$y][$x] = $grid[$transformY][$transformX];
		}
	}
	return $newGrid;
}

function find_rule($grid) {
	global $rules;
	global $transforms;

	$size = sizeof($grid);
	foreach($rules as $rule) {
		if(sizeof($rule['from']) != $size) continue;
		if(match($rule['from'],$grid)) return $rule;
		foreach($transforms as $transform) {
			if(match($rule['from'], apply_transform($grid, $transform))) {
				return $rule;
			}
		}
	}
	echo "Unable to find rule\n";
	print_r($grid);
	die();
}

function divide($grid,$y,$x,$square) {
	$subgrid = [];

	$y = $y*$square;
	$x = $x*$square;
	for($row=$y; $row<$y+$square; $row++) {
		$cols = [];
		for($col=$x; $col<$x+$square; $col++) {
			$cols[] = $grid[$row][$col];
		}
		$subgrid[] = $cols;
	}
	return $subgrid;
}

function insert($grid,$y, $x, $subgrid) {
	$size = sizeof($subgrid);
	$y = $y*$size;
	$x = $x*$size;
	for($row=0; $row<$size; $row++) {
		for($col=0; $col<$size; $col++) {
			$grid[$y+$row][$x+$col] = $subgrid[$row][$col];
		}
	}
	return $grid;
}

function process($grid) {
	$size = sizeof($grid);
	if($size % 2 == 0) {
		$square = 2;
		$squares = $size / 2;
	} else {
		$square = 3;
		$squares = $size / 3;
	}
	
	$newGrid = [];
	for($y=0;$y<$squares;$y++) {
		for($x=0;$x<$squares;$x++) {
			$subgrid = divide($grid,$y,$x,$square);
			$newGrid = insert($newGrid, $y, $x, find_rule($subgrid)['to']);
		}
	}
	return $newGrid;
}

for($c=0; $c<$iterations; $c++) {
	$grid = process($grid);
}

$count = 0;
foreach($grid as $row) {
	foreach($row as $col) {
		if($col == "#") {
			$count++;
		}
	}
}
echo "Count = $count\n";
