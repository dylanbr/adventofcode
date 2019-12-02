<?php

require("data.php");

$program = array_map(function($line) {
	list($op,$target,$value) = explode(" ",$line);
	return [
		'op'=>$op,
		'target'=>$target,
		'value'=>(isset($value)?$value:false)
	];
},explode("\n",$data));

$registers = [];
function get($target) {
	global $registers;

	if(is_numeric($target)) {
		return $target;
	}

	if(!array_key_exists($target,$registers)) {
		$registers[$target] = 0;
	}

	return $registers[$target];
}

$lines = sizeof($program);
$count = 0;
for($line=0;$line<$lines;) {
	$next = true;
	$step = $program[$line];
	$target = $step['target'];
	$value = $step['value'];
	switch($step['op']) {
	case 'set':
		$registers[$target] = get($value);
		break;
	case 'add':
		$registers[$target] = get($target) + get($value);
		break;
	case 'sub':
		$registers[$target] = get($target) - get($value);
		break;
	case 'mul':
		$registers[$target] = get($target) * get($value);
		$count++;
		break;
	case 'jnz':
		if(get($target) != 0) {
			$line += get($value);
			$next = false;
		}
		break;
	}
	if($next) {
		$line++;
	}
	echo "Line = $line\r";
}
echo "\n";
echo "MUL called $count times\n";
