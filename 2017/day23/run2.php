<?php

// https://stackoverflow.com/questions/38008130/php-check-if-number-is-prime
function is_prime($n) {
	for($i=$n>>1;$i&&$n%$i--;);
	return!$i&&$n>1;
}

$start = 106500;
$iterations = 1000;
$found = 0;
for($count = 0; $count < $iterations; $count++) {
	$found += is_prime($start + $count)?0:1;
}
echo "Found = $found\n";

