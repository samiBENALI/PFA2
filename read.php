<?php

$myfile = fopen("output", "r"); //here we read the motor's speed stored in the output file written by the control script
$sam2=fread($myfile,filesize("output"));
fclose($myfile);



echo $sam2; 
?>






