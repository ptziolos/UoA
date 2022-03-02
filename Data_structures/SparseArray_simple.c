#include <stdio.h>
#include <stdlib.h>

typedef struct node *np;

struct node
{
	int i,j,v,w; //value, wave
    np p,n,u,d; //previous, next, up, down
};

np temp, aux, aux1, aux2;


void insert1(int N, np R[], np C[]);
void print1(int N, np R[]);
void delete1(int N, np R[]);


int main (void)
{
    printf("\nThis programme simulates a sparce array\n");
	
	int N;
	printf("\nPlease enter the number of cells for the arrays\t");
	scanf("%d",&N);
	printf("N=%d\n",N);
	
	int m;
	np R[N+1],C[N+1];
	
	for (m=0;m<N+1;m++)
	{
		R[m]=(np)malloc(sizeof(struct node));
		C[m]=(np)malloc(sizeof(struct node));
		
		C[m]->i=0;
		C[m]->j=m;
		C[m]->v=0;
		C[m]->w=0;
		C[m]->u=NULL;
		C[m]->d=NULL;
		C[m]->n=NULL;
		C[m]->p=NULL;

		R[m]->j=0;
		R[m]->i=m;
		R[m]->v=0;
		R[m]->w=0;
		R[m]->n=NULL;
		R[m]->p=NULL;
		R[m]->u=NULL;
		R[m]->d=NULL;
	}
	
	for (m=0;m<N+1;m++)
	{
		if (m<N)
		{
			R[m]->d=R[m+1];
			C[m]->n=C[m+1];
		}
		else if (m==N)
		{
			R[m]->d=NULL;
			C[m]->n=NULL;
		}
	}
	
	for (m=N;m>0;m--)
	{
		if (m>0)
		{
			R[m]->u=R[m-1];
			C[m]->p=C[m-1];
		}
		else if (m==0)
		{
			R[m]->u=NULL;
			C[m]->p=NULL;
		}
	}

	char s = '*';
	
    while (s != 'q')
    {
        printf("\n insert(i), print(p), delete(d), quit(q)\n");
        scanf("\n %c", &s);
		
        if (s == 'i')
        {
			printf("INSERT\n");
			insert1(N, R, C);
        }
        else if (s == 'p')
        {
			printf("PRINT\n");
			print1(N, R);
        }
        else if (s == 'd')
        {
			printf("DELETE\n");
			delete1(N, R);
        }
    }
printf("QUIT\n");
return 0;
}


void insert1(int N, np R[], np C[])
{ 
	np temp,aux1=NULL,aux2=NULL;
	int value,row,column;
	
	temp=(np)malloc(sizeof(struct node));
	
	printf("\n Please enter the value you want to store\n");
	scanf("%d",&value);
	
	do{
		printf("\n Please enter the row of the cell in which you want to store the value\n");
		scanf("%d",&row);
	}while ((row < 1) || (row > N));
	
	do{
		printf("\n Please enter the column of the cell in which you want to store the value\n");
		scanf("%d",&column);
	}while ((column < 1) || (column > N));

	temp->v=value;
	temp->i=row;
	temp->j=column;
	temp->n=NULL;
	temp->p=NULL;
	temp->u=NULL;
	temp->d=NULL;

	printf("\n The value of temp is %d \n", temp->v);
	
	if (R[row]->n == NULL)
	{
		R[row]->n=temp;
		temp->p=R[row];
	}
	else if (R[row]->n != NULL)
	{
		aux1=R[row];
		while (aux1->n != NULL && temp->j > aux1->n->j)
		{
			aux1=aux1->n;
		}
		temp->n=aux1->n;
		temp->p=aux1;
		aux1->n=temp;
		if (temp->n != NULL)
		{
			temp->n->p=temp;
		}
	}
	
	if (C[column]->d == NULL)
	{
		C[column]->d=temp;
		temp->u=C[column];
	}
	else if (C[column]->d != NULL)
	{
		aux2=C[column];
		while (aux2->d != NULL && temp->i > aux2->d->i)
		{
			aux2=aux2->d;
		}
		temp->d=aux2->d;
		temp->u=aux2;
		aux2->d=temp;
		if (temp->d != NULL)
		{
			temp->d->u=temp;
		}
	}
}


void print1(int N, np R[])
{
	np aux;
	int m;
	
	for (m=1;m<=N;m++)
	{
		aux=R[m];
		while (aux->n!=NULL)
		{ 	
			printf("\n The value of cell [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->v);
			if (aux->n->u != NULL)
				printf("\n The up of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->u->v);
			if (aux->n->d != NULL)	
				printf("\n The down of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->d->v);
			if (aux->n->n != NULL)
				printf("\n The next of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->n->v);
			if (aux->n->p != NULL)
				printf("\n The previous of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->p->v);
			aux=aux->n;
		}
	}
}

	
void delete1(int N, np R[])
{
	int row, column;
	np aux,temp;
	
	printf("\n Please enter the row of the cell you want to delete\n");
	scanf("%d",&row);
	
	printf("\n Please enter the column of the cell you want to delete\n");
	scanf("%d",&column);
	
	aux=R[row];
	while (aux->n != NULL && aux->n->j != column)
	{
		aux=aux->n;
	}
	
	if (aux->n == NULL)
	{
		printf("\n The cell [%d,%d] does not exist\n",row,column);
	}
	else if (aux->n->j == column)
	{
		temp=aux->n;
		temp->u->d=temp->d;
		aux->n=temp->n;
		if (temp->d != NULL)
		{
			temp->d->u=temp->u;
		}
		else if (temp->n !=NULL)
		{
			temp->n->p=aux;
		}
		free(temp);
		printf("\n The cell [%d,%d] has been deleted\n",row,column);
	}
}
