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
void insert2(np *aux1, np *temp);
void insert3(np *aux2, np *temp);
void print1(np aux);
void unprint1(np aux);
void delete1(int N, np R[]);
void delete2(int row,int column,np aux);


// Menu and definition of the arrays
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
		C[m]->w=1;
		C[m]->u=NULL;
		C[m]->d=NULL;
		C[m]->n=NULL;
		C[m]->p=NULL;

		R[m]->j=0;
		R[m]->i=m;
		R[m]->v=0;
		R[m]->w=1;
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
			print1(R[0]);
			unprint1(R[0]);
        }
        else if (s == 'd')
        {
			printf("DELETE\n");
			delete1(N, R);
        }
    }
printf("\nQUIT\n");
return 0;
}


// Insertion of elements and check if the cell already exists - O(1)
void insert1(int N, np R[], np C[])
{ 
	np rip=NULL;
	int value,row,column;
	char s;
	
	temp=(np)malloc(sizeof(struct node));
	s='*';
	
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
	
	aux=R[row];
	while (aux->n != NULL && aux->n->j != column) 
	{
		aux=aux->n;
	}
	
	if (aux->n != NULL && aux->n->j == column && aux->n->i == row)
	{
		printf("\n The cell [%d,%d] already exists\n",aux->n->i, aux->n->j);
		do{
			printf("\n If you want to replace the value of the cell press 'y' otherwise press 'n'\n");
			scanf("\n %c", &s);
		}while (s != 'y' && s != 'n');
		printf("\n ok\n");
	}
	
	if (s == 'y')
	{
		rip=aux->n;
		rip->u->d=rip->d;
		aux->n=rip->n;
		if (rip->d != NULL)
		{
			rip->d->u=rip->u;
		}
		else if (rip->n !=NULL)
		{
			rip->n->p=aux;
		}
		free(rip);
	}
	else if (s == 'n')
	{
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
	}
	
	if (R[row]->n == NULL)
	{
		R[row]->n=temp;
		temp->p=R[row];
	}
	else if (R[row]->n != NULL)
	{
		aux1=R[row];
		insert2(&aux1, &temp);
	}
	
	if (C[column]->d == NULL)
	{
		C[column]->d=temp;
		temp->u=C[column];
	}
	else if (C[column]->d != NULL)
	{
		aux2=C[column];
		insert3(&aux2, &temp);
	}
}


// Connection of the new cell with its neighboring nodes that reside at the left and the right of it - 
// O(k), k is the number of the cells of the horizontal and the vertical arrays
void insert2(np *aux1, np *temp)
{
	np rex, tempo;
	
	rex=(*aux1);
	tempo=(*temp);
	
	if (rex->n == NULL)
	{
		rex->n=tempo;
		tempo->p=rex;
		(*temp)=tempo;
		(*aux1)=rex;
	}
	else if (rex->n != NULL && tempo->j > rex->n->j)
	{
		rex=rex->n;
		insert2(&rex, &tempo);
	}
	else if (rex->n != NULL && tempo->j < rex->n->j)
	{
		tempo->n=rex->n;
		tempo->p=rex;
		rex->n=tempo;
		if (tempo->n != NULL)
		{
			tempo->n->p=tempo;
		}
		(*temp)=tempo;
		(*aux1)=rex;
	}
}


// Connection of the new cell with its neighboring nodes that reside above and under it - 
// O(k), k is the number of the cells of the horizontal and the vertical arrays
void insert3(np *aux2, np *temp)
{
	np rex, tempo;
	
	rex=(*aux2);
	tempo=(*temp);
	
	if (rex->d == NULL)
	{
		rex->d=tempo;
		tempo->u=rex;
		(*temp)=tempo;
		(*aux2)=rex;
	}
	else if (rex->d != NULL && tempo->i > rex->d->i)
	{
		rex=rex->d;
		insert3(&rex, &tempo);
	}
	else if (rex->d != NULL && tempo->i < rex->d->i)
	{
		tempo->d=rex->d;
		tempo->u=rex;
		rex->d=tempo;
		if (tempo->d != NULL)
		{
			tempo->d->u=tempo;
		}
		(*temp)=tempo;
		(*aux2)=rex;
	}
}


// Printing of the nodes and its neighbores - O(n), n is the number of 
// the nodes that have been inserted
void print1(np aux)
{
	np rex;
	
	rex=aux;
	
	if (rex->n != NULL && rex->n->w == 0)
	{
		printf("\n The value of cell [%d,%d] is %d",rex->n->i, rex->n->j, rex->n->v);
		if (rex->n->u != NULL && rex->n->u->i != 0)
			printf("\n The up of [%d,%d] is [%d,%d]",rex->n->i, rex->n->j, rex->n->u->i, rex->n->u->j);
		if (rex->n->d != NULL)	
			printf("\n The down of [%d,%d] is [%d,%d]",rex->n->i, rex->n->j, rex->n->d->i, rex->n->d->j);
		if (rex->n->n != NULL)
			printf("\n The next of [%d,%d] is [%d,%d]",rex->n->i, rex->n->j, rex->n->n->i, rex->n->n->j);
		if (rex->n->p != NULL && rex->n->p->j != 0)
			printf("\n The previous of [%d,%d] is [%d,%d]",rex->n->i, rex->n->j, rex->n->p->i, rex->n->p->j);
	    printf("\n");
		rex->n->w=1;
		print1(rex->n);
	}
	
	if (rex->d != NULL && rex->d->j == 0)
	{
		print1(rex->d);
	}
}	


// Unmarking of the nodes - O(n), n is the number of the nodes that have been inserted
void unprint1(np aux)
{
	np rex;
	
	rex=aux;
	
	if (rex->n != NULL && rex->n->w == 1 && rex->n->v != 0)
	{
		rex->n->w=0;
		unprint1(rex->n);
	}
	
	if (rex->p != NULL && rex->p->w == 1 && rex->p->v != 0)
	{
		rex->p->w=0;
		unprint1(rex->p);
	}
	
	if (rex->d != NULL && rex->d->j == 0)
	{
		unprint1(rex->d);
	}
}


// Insertion of the cell which is going to be deleted - O(1) 
void delete1(int N, np R[])
{
	int row, column;
	
	printf("\n Please enter the row of the cell you want to delete\n");
	scanf("%d",&row);
	
	printf("\n Please enter the column of the cell you want to delete\n");
	scanf("%d",&column);
	
	aux=R[row];
	delete2(row,column,aux);
}


// Detection and deletion of the node - O(k), k is the number of the cells 
// of the horizontal and the vertical arrays
void delete2(int row,int column,np aux)
{
	if (aux->n != NULL && aux->n->j != column)
	{
		delete2(row,column,aux->n);
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
		
		if (temp->n !=NULL)
		{
			temp->n->p=aux;
		}
		
		free(temp);
		printf("\n The cell [%d,%d] has been deleted\n",row,column);
	}
}
