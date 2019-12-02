<?php

require("data.php");

/*
$data = "Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.";
//*/

$lines = explode("\n",$data);

$start = false;
$steps = false;
$rule = false;
$rules = false;
$check = false;
foreach($lines as $line) {
	if($start === false && preg_match("/Begin in state (.)\\./",$line,$matches)) {
		$start = $matches[1];
		continue;
	}
	if($steps === false && preg_match("/Perform a diagnostic checksum after (\d+) steps\\./",$line,$matches)) {
		$steps = $matches[1];
		continue;
	}
	if(preg_match("/In state (.):/",$line,$matches)) {
		$rule = $matches[1];
		$rules[$rule] = [];
	}
	if(preg_match("/If the current value is (\d):/",$line,$matches)) {
		$check = $matches[1];
		$rules[$rule][$check] = [];
	}
	if(preg_match("/Write the value (\d)\\./", $line,$matches)) {
		$rules[$rule][$check][] = [
			'op'=>"set",
			'value'=>$matches[1]
		];
	}
	if(preg_match("/Move one slot to the (.+)\\./",$line,$matches)) {
		$rules[$rule][$check][] = [
			'op'=>"move",
			'value'=>($matches[1]=="right"?1:-1)
		];
	}
	if(preg_match("/Continue with state (.)\\./",$line,$matches)) {
		$rules[$rule][$check][] = [
			'op'=>"next",
			'value'=>$matches[1]
		];
	}

}
echo "Start = $start\n";
echo "Steps = $steps\n";

$tape = [];
$position = 0;
$state = $start;
for($c=0;$c<$steps;$c++) {
	if(!array_key_exists($position,$tape)) {
		$tape[$position] = 0;
	}
	foreach($rules[$state][$tape[$position]] as $instruction) {
		switch($instruction['op']) {
		case "set":
			$tape[$position] = $instruction['value'];
			break;
		case "move":
			$position += $instruction['value'];
			break;
		case "next":
			$state = $instruction['value'];
			break;
		}
	}
	echo "Step " . ($c+1) ." of $steps\r";
}
echo "\n";

$checksum = array_reduce($tape, function($carry, $value) {
	return $carry + $value;
},0);
echo "Checksum = $checksum\n";
