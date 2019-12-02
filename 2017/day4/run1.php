<?php

require("data.php");

$phrases = explode("\n",$data);
$valid = 0;
$invalid = 0;
foreach($phrases as $phrase) {
	$words = explode(" ",$phrase);
	$total = sizeof($words);
	$words = array_unique($words);
	$unique = sizeof($words);
	if($total == $unique) {
		$valid++;
	} else {
		$invalid++;
	}
}
echo "Valid = $valid (Invalid = $invalid)\n";
