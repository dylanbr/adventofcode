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

follow(0);
echo "Found " . sizeof($seen) . " programs in group containing program 0\n";
