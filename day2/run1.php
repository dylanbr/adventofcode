<?php

require("data.php");

$table = explode("\n",$data);
foreach($table as &$row) {
	$row = explode("\t",$row);
}
unset($row);

$checksum = 0;
foreach($table as $row) {
	$smallest = false;
	$largest = false;
	foreach($row as $cell) {
		if($smallest === false || $cell < $smallest) {
			$smallest = $cell;
		}
		if($largest === false || $cell > $largest) {
			$largest = $cell;
		}
	}
	$checksum += $largest - $smallest;
}
echo "Checksum = $checksum\n";
