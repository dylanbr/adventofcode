<?php

require('data.php');
//$data = 3;

$loop = $data;
$curr = 0;

$last = false;
for($c=1;$c<=50000000;$c++) {
	$curr = (($curr + $loop) % $c) + 1;
	if($curr == 1) {
		$last = $c;
		echo "Last = $last\r";	
	}
}
echo "Result = $last\n";
