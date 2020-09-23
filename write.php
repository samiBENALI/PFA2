<?php
$sam=$_POST['postRPM'];  //here we save the user input in a local file to be late$
$myfile = fopen("input", "w");
fwrite($myfile, $sam);
fclose($myfile);
//here we rise an interrupt to the control program indicating that the input has changed
//first we need to get the control program process ID by reading the pid file :

shell_exec("line=$(head -n 1 pid)"); //reads the first line of the file 
shell_exec("kill -USR2 $line "); //sends the signal 
);
?>


