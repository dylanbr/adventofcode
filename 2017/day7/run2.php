<?php

require("data1.php");

global $nodes;

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
$bottom = array_pop(array_diff($allNodes,$allChildren));

function find_weight($bottom) {
	global $nodes;

	$total = 0;
	if(sizeof($nodes[$bottom]['children']) > 0) {
		$balances = [];
		foreach($nodes[$bottom]['children'] as $childKey=>$child) {
			$child_weight = find_weight($child);
			if(!array_key_exists($child_weight,$balances)) {
				$balances[$child_weight] = [];
			}
			$balances[$child_weight][] = $child;
			$total += $child_weight;
		}
		if(sizeof($balances) > 1) {
			$smallest = false;
			$largest = false;
			foreach($balances as $balance) {
				if($smallest === false || sizeof($balance) < sizeof($smallest)) {
					$smallest = $balance;
				}
				if($largest === false || sizeof($balance) > sizeof($largest)) {
					$largest = $balance;
				}
			}
			$correctWeight = find_weight($largest[0]);
			$incorrectWeight = find_weight($smallest[0]);
			$diffWeight = $correctWeight - $incorrectWeight;
			//echo "The total weight of $smallest[0] should be $correctWeight but is $incorrectWeight\n";
			//echo "A difference of $diffWeight must be accounted for.\n";
			echo "Program $smallest[0] weighs " . $nodes[$smallest[0]]['weight'] . " but should weigh " . ($nodes[$smallest[0]]['weight'] + $diffWeight). "\n";
			die();
		}
	}
	$total += $nodes[$bottom]['weight'];
	return $total;
}
find_weight($bottom);
