#include <stdio.h>
#include <pthread.h>
#include <Math.h>
#define num_char 100

void *print(void *arg)
{
    int i;
    double y[num_char],x[num_char];
    const int c = *((int*)arg);
    
    
    for(i=1;i<=num_char;i++)
    {
        x[i]=0.1*i;
        y[i]=exp((-c)*x[i]);
        printf("\texp(c*x)=%lf\t",y[i]);
    }
    
    return NULL;
}

int main(void)
{
    pthread_t t1, t2 ,t3;
    int k=1,s=0,l=-1;
    char c='*';
    
    printf("\nk=1,s=0,l=-1\nif you want to change their values press 'y'");
    scanf("%c",&c);
    
    if (c=='y')
    {
    printf("Plz enter the value of k");
    scanf("%d",&k);
    printf("Plz enter the value of s");
    scanf("%d",&s);
    printf("Plz enter the value of l");
    scanf("%d",&l);
	}
    
    
    printf("\n Creating Threads\n");
    pthread_create(&t1,NULL,print,&k);
    pthread_create(&t2,NULL,print,&s);
    pthread_create(&t3,NULL,print,&l);
    
    printf("\n Joining Threads\n");
    pthread_join(t1,NULL);
    pthread_join(t2,NULL);
    pthread_join(t3,NULL);
    
    printf("\nExiting\n");
    return 0;
}
