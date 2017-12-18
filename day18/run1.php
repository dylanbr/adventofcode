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
$freq = 0;
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
for($line=0;$line<$lines;) {
	$next = true;
	$step = $program[$line];
	$target = $step['target'];
	$value = $step['value'];
	switch($step['op']) {
	case 'snd':
		$freq = get($target);	
		break;
	case 'set':
		$registers[$target] = get($value);
		break;
	case 'add':
		$registers[$target] = get($target) + get($value);
		break;
	case 'mul':
		$registers[$target] = get($target) * get($value);
		break;
	case 'mod':
		$registers[$target] = get($target) % get($value);
		break;
	case 'rcv':
		if($freq != 0) {
			$registers[$target] = $freq;
			echo "Frequency = $freq\n";
			die();
		}
		break;
	case 'jgz':
		if(get($target) > 0) {
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

