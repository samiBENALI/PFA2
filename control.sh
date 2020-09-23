#!/bin/bash
#writes its pid to the pid file :
echo $$>pid
#we write a zero to the input and the output file to reset them :
echo "0">input
echo "0">output
#executes the input program in backround (gives it this process id so it can signal us) :
./rpm $$ &
#starts the apache server : 
systemctl start apache2.service
#now we declare our variables :
current_rpm=0
demnded_rpm=0
Pgain=0
Igain=0
Dgain=0
error=0
prev_error=0
ac_error=0
duty=0  #intially d: the duty cycle is set to 0 
T=200000000 #200 ms

PID=0
conversion_gain=0

#declaring the interrupt routines (for the signals) :
sigusr1()
{
line=$(head -n 1 output)
current_rpm=$line

}
sigusr2()
{
fline=$(head -n 1 input)
demanded_rpm=$fline

}

trap sigusr1 USR1       # catch -USR1 signal

trap sigusr2 USR2       # catch -USR2 signal




#we setup the bbb pwm (configuration) :

if [ ! -e /root/EHRPWM1/pwm0 ]; then
        echo 0 > /root/EHRPWM1/export
fi
 echo 1 > /root/EHRPWM1/pwm0/enable
 echo $T > /root/EHRPWM1/pwm0/period
 echo $d > /root/EHRPWM1/pwm0/duty_cycle
 echo pwm > /sys/devices/platform/ocp/ocp:P9_14_pinmux/stateln -s /sys/devices/platform/ocp/48302000.epwmss/48302200.pwm/pwm/pwmchip* EHRPWM1

#now we loop forever to control the system :

while true 
do 

((error=$demanded_rpm-$current_rpm))

((ac_error=$error+$ac_error))


((PID= $Pgain*$error + $Igain*$ac_error + $Dgain*($error-$prev_error)))

((prev_error=$error))

#now we convert the output value from an RPM to a duty cycle by deviding it by the conversin gain :

duty=`expr $PID / $conversion_gain`

#keeping the duty cycle from exeeding the maximum or going under the minimum value :
if [ $duty -gt 500 ]
then
   duty=500
fi

if [ 0 -gt $duty ]
then
   $duty=0
fi

echo $duty > /root/EHRPWM1/pwm0/duty_cycle

done 


exit 0

