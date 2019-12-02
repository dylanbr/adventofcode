<?php

ini_set('memory_limit','1024M');

require("data.php");

$components = array_map(function($component) {
	return explode("/",$component);
},explode("\n",$data));

function combine($new, $value, $bridge=[]) {
	global $components;
	global $bridges;
	
	$bridge[] = $new;
	if($components[$new][0] == $value) {
		$target = $components[$new][1];
	} else {
		$target = $components[$new][0];
	}

	$found = false;
	foreach($components as $key=>$component) {
		if(in_array($key, $bridge)) {
			continue;
		}
		if(in_array($target, $component)) {
			combine($key, $target, $bridge);
			$found = true;
		}
	}
	if(!$found) {
		$bridges[] = $bridge;
		echo "Found " . sizeof($bridges) . " bridges\r";
	}
}

$bridges = [];
foreach($components as $key=>$component) {
	if(in_array(0,$component)) {
		combine($key, 0);
	}
}
echo "\n";

$max = 0;
foreach($bridges as $bridge) {
	$value = array_reduce($bridge,function($carry, $key) {
		global $components;

		return $carry + $components[$key][0] + $components[$key][1];
	},0);
	if($value > $max) {
		$max = $value;
	}
}
echo "Max = $max\n";
