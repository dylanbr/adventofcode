<?php

require("data.php");

$table = explode("\n",$data);
foreach($table as &$row) {
	$row = explode("\t",$row);
}
unset($row);

$checksum = 0;
foreach($table as $row) {
	$found = false;
	foreach($row as $cell1=>$value1) {
		foreach($row as $cell2=>$value2) {
			if($cell1 == $cell2) {
				continue;
			}
			if($value1 % $value2 == 0 ) {
				$found = true;
				$checksum += $value1/$value2;
				break;
			}
		}
		if($found) {
			break;
		}
	}
}
echo "Checksum = $checksum\n";
