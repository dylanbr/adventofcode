<?php

require("data.php");

define(A,0);
define(B,1);

//$data = [65, 8921];

$factors = [16807, 48271];
$prev = $data;
$curr = [];

$matches = 0;
for($c=0;$c<40000000;$c++) {
	foreach([A,B] as $gen) {
		$prev[$gen] = ($prev[$gen] * $factors[$gen]) % 2147483647;
		$curr[$gen] = $prev[$gen] & 65535;
	}
	if($curr[A] == $curr[B]) { $matches++; }
}
echo "Matches = $matches\n";

