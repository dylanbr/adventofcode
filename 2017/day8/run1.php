<?php

require("data.php");

$data = explode("\n",$data);
$code = [];
foreach($data as $line) {
	$code[] = explode(" ", $line);
}

$vars = [];
foreach($code as $ins) {
	$var = $ins[0];
	$op = $ins[1];
	$val = $ins[2];
	$cvar = $ins[4];
	$cop = $ins[5];
	$cval = $ins[6];

	if(!array_key_exists($var,$vars)) {
		$vars[$var] = 0;
	}

	if(!array_key_exists($cvar,$vars)) {
		$vars[$cvar] = 0;
	}

	if($op == "inc") { $op = "+"; } else { $op = "-"; }

	eval("if(\$vars['$cvar'] $cop $cval) { \$vars['$var'] $op= $val; }");
}

$max = false;
foreach($vars as $var=>$val) {
	if($max === false || $max < $val) {
		$max = $val;
	}
}

echo "Largest value = $max\n";
