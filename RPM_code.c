#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <poll.h>
#include <time.h>
#include<string.h>
#include <signal.h>


int main(int argc, char *argv[])
{
int f;
int fout;
struct pollfd poll_fds[1];
int ret;
int n;
int counter=0;
int RPM=0;
int pulsesperturn = 20;
int result=0;
char buf[12]; 
int pid_number;
time_t curtime;
time(&curtime);

char  prev_time[50];
strcpy(prev_time,ctime(&curtime));

f = open("/sys/class/gpio/gpio47/value", O_RDONLY);
if (f == -1) {
perror("Can't open gpio47");
return 1;
}


poll_fds[0].fd = f;
poll_fds[0].events = POLLPRI | POLLERR;
while (1) {

printf("Waiting\n");
ret = poll(poll_fds, 1, 0);
if (ret > 0) {
counter++;



}
time(&curtime);
result = strcmp(prev_time, ctime(&curtime));


if (result!=0)
{ strcpy(prev_time,ctime(&curtime));
RPM= 60* (counter / pulsesperturn);
//we convert the value to a string :

itoa(RPM, buf, 24);
//here we write to the output file 

fout = open("output", O_WRONLY | O_APPEND);
write(fout, buf, strlen(buf)); 
close(fout);
//here we rise the interrupt for the control script :

pid_number=atoi(argv[1]);
kill(pid_number, SIGUSR1);


printf("Current time = %s", ctime(&curtime));
counter =0;
result=0;
}
}
return 0;
}
