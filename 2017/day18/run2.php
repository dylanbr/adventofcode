<?php

require("data.php");

/*
$data = "snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d";
*/

define("A",1);
define("B",2);

$program = array_map(function($line) {
	list($op,$target,$value) = explode(" ",$line);
	return [
		'op'=>$op,
		'target'=>$target,
		'value'=>(isset($value)?$value:false)
	];
},explode("\n",$data));

function get($process,$target) {
	global $states;

	if(is_numeric($target)) {
		return $target;
	}

	$registers =& $states[$process]['registers'];
	if(!array_key_exists($target,$registers)) {
		$registers[$target] = 0;
	}

	$value = $registers[$target];
	unset($registers);
	return $value;
}

$done = false;
$lines = sizeof($program);
$process = A;
$states = [
	A=>['terminated'=>false, 'waiting'=>false, 'line'=>0, 'registers'=>['p'=>0], 'queue'=>[], 'sent'=>0],
	B=>['terminated'=>false, 'waiting'=>false, 'line'=>0, 'registers'=>['p'=>1], 'queue'=>[], 'sent'=>0]
];
while(!$done) {
	$state =& $states[$process];
	if(!$state['terminated']) {
		$line =& $state['line'];
		$registers =& $state['registers'];
		$queue =& $state['queue'];
		$sent =& $state['sent'];

		$next = true;
		$step = $program[$line];
		$target = $step['target'];
		$value = $step['value'];

		switch($step['op']) {
		case 'snd':
			$queue[] = get($process,$target);
			$sent++;
			break;
		case 'set':
			$registers[$target] = get($process,$value);
			break;
		case 'add':
			$registers[$target] = get($process,$target) + get($process,$value);
			break;
		case 'mul':
			$registers[$target] = get($process,$target) * get($process,$value);
			break;
		case 'mod':
			$registers[$target] = get($process,$target) % get($process,$value);
			break;
		case 'rcv':
			$other = ($process==A?B:A);
			if(sizeof($states[$other]['queue']) > 0) {
				$registers[$target] = array_shift($states[$other]['queue']);
			} else {
				$state['waiting'] = true;
				$next = false;
			}
			break;
		case 'jgz':
			if(get($process,$target) > 0) {
				$line += get($process,$value);
				$next = false;
			}
			break;
		}
		if($next) {
			$line++;
		}
		if($line < 0 || $line >= $lines) {
			$state['terminated'] = true;
		}
		unset($line);
		unset($registers);
		unset($queue);
		unset($sent);
	}
	$process = ($process==A?B:A);
	unset($state);
	$done = (
		($states[A]['terminated'] || $states[A]['waiting'])
		&&
		($states[B]['terminated'] || $states[B]['waiting'])
	);
}

echo "Process B sent " . ($states[B]['sent']) . " values\n";
