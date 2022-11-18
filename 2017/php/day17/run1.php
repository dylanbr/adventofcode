<?php

require('data.php');
//$data = 3;

$loop = $data;
$lock = [0];
$curr = 0;

for($c=0;$c<2017;$c++) {
	$curr = (($curr + $loop) % ($c + 1)) + 1;
	array_splice($lock,$curr,0,$c+1);
}
echo "Result = " . $lock[$curr+1] . "\n";
