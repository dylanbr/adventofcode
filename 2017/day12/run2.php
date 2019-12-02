<?php

require("data.php");

$lines = explode("\n",$data);
$links = [];
foreach($lines as $line) {
	list($parent, $children) = explode(" <-> ",$line);
	$links[$parent] = explode(", ",$children);
}

$seen = [];
function follow($curr) {
	global $links;
	global $seen;

	if(!in_array($curr, $seen)) {
		$seen[] = $curr;
		foreach($links[$curr] as $child) {
			follow($child);
		}
	}
}

$groups = 0;
foreach($links as $parent=>$children) {
	if(!in_array($parent, $seen)) {
		follow($parent);
		$groups++;
	}
}

echo "Found " . $groups . " groups in total\n";
