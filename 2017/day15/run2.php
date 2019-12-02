<?php

ini_set('memory_limit','1024M');

require("data.php");

define(A,0);
define(B,1);

//$data = [65, 8921];
$target = 5000000;

$factors = [16807, 48271];
$mods = [4, 8];
$prev = $data;

$found = [0,0];
$values = [
	A=>[],
	B=>[]
];

while($found[A] < $target || $found[B] < $target) {
	foreach([A,B] as $gen) {
		if($found[$gen] < $target) {
			$prev[$gen] = ($prev[$gen] * $factors[$gen]) % 2147483647;
			if(($prev[$gen] % $mods[$gen]) == 0) {
				$found[$gen]++;
				$values[$gen][] = $prev[$gen] & 65535;
			}
		}
	}
}

$matches = array_reduce(
	array_map(function($a,$b) {
		return $a == $b?1:0;
	},$values[A],$values[B]),

	function($matches, $item) {
		return $matches + $item;
	}
);
echo "Matches = $matches\n";

