#include <stdio.h>
#include <pthread.h>

#define num_char 1000

void *print(void *arg)
{
    int i;
    const int c = *((int*)arg);
    
    for (i=0;i<num_char;i++)
        putchar(c);
    
    return NULL;
}

int main(void)
{
    pthread_t t1, t2;
    char a='*',h='#';
    
    printf("\n Creating Threads\n");
    pthread_create(&t1,NULL,print,&a);
    pthread_create(&t2,NULL,print,&h);
    
    printf("\n Joining Threads\n");
    pthread_join(t1,NULL);
    pthread_join(t2,NULL);
    
    printf("\nExiting\n");
    return 0;
}