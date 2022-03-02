#include <stdio.h>
#include <stdlib.h>

typedef struct tf  *tp;

struct tf
{
	int am;
	double gr;
	tp prev;
	tp next;
};

tp head, tail, temp, aux;

void insert(tp *head,tp *tail);
void print1(tp head);
void print2(tp head);
void delet(tp *head,tp *tail);

int main (void)
{
	char c = '*';
    	printf("\nThis programme simulates a dual linked list\n");
	head=NULL;
	tail=NULL;

    while (c != 'q')
    {
        printf("\n insert(i), print(p), delete(d), quit(q)\n");
        scanf("\n %c", &c);

        if (c == 'i')
        {
			printf("INSERT\n");
			insert(&head,&tail);
        }
        else if (c == 'p')
        {
			printf("PRINT\n");
			print2(head);
        }
        else if (c == 'd')
        {
			printf("DELETE\n");
			delet(&head,&tail);
        }
    }
printf("QUIT\n");
return 0;
}

void insert(tp *head,tp *tail)
{ 
	tp temp,aux;
	int key;
	
	temp=(tp)malloc(sizeof(struct tf));
	printf("\n Give me the AM interger \n");
	scanf("%d",&key);

	temp->am=key;
	temp->next=NULL;
	temp->prev=NULL;

	printf("\n The AM of temp is %d \n", temp->am);

	if ((*head!=NULL) && ((*head)->next!=NULL)&& (temp->am<(*head)->am))
	{	
		temp->next=*head;
		temp->prev=*tail;
		(*head)->prev=temp;
		(*head)=temp;
	}
	if ((*head!=NULL) && ((*head)->next!=NULL) && (temp->am>(*head)->am))
	{	
		aux=(*head);
		while((aux->next!=NULL) && (aux->next->am<temp->am))
			{	aux=aux->next;}
		temp->next=aux->next;
		temp->prev=aux;
		aux->next=temp;
		if (temp->next!=NULL)
			temp->next->prev=temp; //////
		if (aux==*tail) 
			(*tail)=temp;
	}
	if((*head!=NULL) && ((*head)->next==NULL) && (temp->am>(*head)->am))
	{ 	printf("\n I do QUEUE \n");
		(*head)->next=temp;
		(*tail)=temp;
		(*tail)->next=NULL;
		(*tail)->prev=(*head);
	}
	if((*head!=NULL) && ((*head)->next==NULL) && (temp->am<(*head)->am))
	{ 	printf("\n I do QUEUE \n");
		temp->next=(*head);
		(*head)=temp;
		(*head)->next->prev=(*head);
		(*tail)=(*head)->next;
	}
	if((*head)==NULL)
	{	printf("\n The head is NULL \n");
		(*head)=temp;
		(*head)->next=NULL;
		(*head)->prev=NULL;
		(*tail)=temp;
		printf("\n First %d \n", temp->am);
	}
}

void print1(tp head)
{
	tp aux;
	aux=head;
	while (aux!=NULL)
	{ 	printf("\n Current is %d", aux->am);
		aux=aux->next;
	}
}

void delet(tp *head,tp *tail) 
{
    tp aux;
    tp temp;
    int key;

    printf(" Give me an AM ");
    scanf("%d",&key);
    
    if((*head)==NULL)
    {
        printf(" The list is empty");
    }
    
    if((*head)!=NULL) 
    {	
		if((*head)->am!=key)
        {
			aux=(*head);
        
			while((aux != (*tail)) && (aux->next->am != key))
			{
				aux=aux->next;
			}
            
            if(aux == (*tail))
            {
                printf("THE END\n");
                printf("The am does not exist\n");
            }
            else if (aux->next == *tail)
			{
				temp=aux->next;
				aux->next=NULL;
				(*tail)=aux;
				free(temp);
			}
			else if (aux->next != *tail)
			{
				temp=aux->next;
				temp->next->prev=aux;
				aux->next=temp->next;
				free(temp);
			}
        }
		if ((*head)->am==key)
		{
			if ((*head)->next != NULL)
			{
				aux=*head;
				(*head)=(*head)->next;
				(*head)->prev=NULL;
				free(aux);
			}
			else if ((*head)->next == NULL)
			{
				aux=*head;
				(*head)=NULL;
				free(aux);
			}
		}
	}
}
			
void print2(tp head)
{	
	if (head==NULL)
	{
		printf("\n The list is empty\n");
	}
	else if (head!=NULL)
	{
		tp aux;
		aux=head;

		printf("\n Current is %d ", aux->am);

		if(aux->next!=NULL)
			print2(aux->next);
	}
}
