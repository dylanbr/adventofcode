<?php

require("data.php");

$nums = $data . $data[0];

$prev = false;
$sum = 0;
for($x = 0; $x < strlen($nums); $x++) {
	$curr = $nums[$x];
	if($prev === $curr) {
		$sum += $curr;
	}
	$prev = $curr;
}

echo "Sum is $sum\n";
