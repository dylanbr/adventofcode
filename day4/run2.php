<?php

require("data.php");

$phrases = explode("\n",$data);
$valid = 0;
$invalid = 0;
foreach($phrases as $phrase) {
	$check = true;
	$words = explode(" ",$phrase);
	$total = sizeof($words);
	$words = array_unique($words);
	$unique = sizeof($words);

	if($total != $unique) {
		$check = false;
	}

	foreach($words as &$word) {
		$letters = str_split($word);
		sort($letters);
		$word = implode("",$letters);
	}
	unset($word);
	$words = array_unique($words);
	$annagram = sizeof($words);

	if($annagram != $unique) {
		$check = false;
	}

	if($check) {
		$valid++;
	} else {
		$invalid++;
	}
}
echo "Valid = $valid (Invalid = $invalid)\n";
