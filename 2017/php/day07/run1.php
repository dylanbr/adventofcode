<?php

require("data1.php");

$data = explode("\n",$data);
$nodes = [];
$allChildren = [];
foreach($data as $item) {
	$parts = explode(" -> ", $item);
	$nameWeight = explode(" ", trim($parts[0]));
	$name = $nameWeight[0];
	$weight = str_replace(["(",")"],["",""],$nameWeight[1]);
	$children = [];
	if(isset($parts[1]) && !empty($parts[1])) {
		$children = explode(", ", $parts[1]);
	}

	$nodes[$name] = [
		'name'=>$name,
		'weight'=>$weight,
		'children'=>$children
	];
	if(sizeof($children) > 0) {
		array_push($allChildren, ...$children);
	}
}
$allNodes = array_unique(array_keys($nodes));
$allChildren = array_unique($allChildren);
echo "Program = " . array_pop(array_diff($allNodes,$allChildren)) . "\n";
