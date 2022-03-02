#include <stdio.h>
#include <stdlib.h>

typedef struct node *np;

struct node
{
	int i,j,v,w,m; //value, wave, marking
    np p,n,u,d,a; //previous, next, up, down, ancestor
};

np temp, aux, aux1, aux2, root, h, t;


void insert1(int N, np R[], np C[]);
void print1(int N, np R[]);
void delete1(int N, np R[]);
void find(np R[], np rox, int key);
void create(np R[], np C[], int N);
void push(int key);
void pop(int key);
void mark(np R[], np C[], np nox);


int main (void)
{
    printf("\nThis programme simulates a Sparce Array and a Spanning Tree\n");
	
	int N;
	printf("\nPlease enter the number of cells for the arrays\t");
	scanf("%d",&N);
	printf("\nN=%d\n",N);
	
	int l;
	np R[N+1],C[N+1];
	
	for (l=0;l<N+1;l++)
	{
		R[l]=(np)malloc(sizeof(struct node));
		C[l]=(np)malloc(sizeof(struct node));
		
		C[l]->i=0;
		C[l]->j=l;
		C[l]->v=0;
		C[l]->w=0;
		C[l]->m=0;
		C[l]->u=NULL;
		C[l]->d=NULL;
		C[l]->n=NULL;
		C[l]->p=NULL;

		R[l]->j=0;
		R[l]->i=l;
		R[l]->v=0;
		R[l]->w=0;
		R[l]->m=0;
		R[l]->n=NULL;
		R[l]->p=NULL;
		R[l]->u=NULL;
		R[l]->d=NULL;
	}
	
	for (l=0;l<N+1;l++)
	{
		if (l<N)
		{
			R[l]->d=R[l+1];
			C[l]->n=C[l+1];
		}
		else if (l==N)
		{
			R[l]->d=NULL;
			C[l]->n=NULL;
		}
	}
	
	for (l=N;l>0;l--)
	{
		if (l>0)
		{
			R[l]->u=R[l-1];
			C[l]->p=C[l-1];
		}
		else if (l==0)
		{
			R[l]->u=NULL;
			C[l]->p=NULL;
		}
	}

	char s = '*';
	
    while (s != 'q')
    {
        printf("\n insert(i), print(p), delete(d), create spanning tree(t), quit(q)\n");
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
        else if (s == 't')
        {
			printf("\nCREATE SPANNING TREE\n");
			create(R, C, N);
		}
    }
printf("\nQUIT\n");
return 0;
}


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
	int l;
	
	for (l=1;l<=N;l++)
	{
		aux=R[l];
		while (aux->n!=NULL)
		{ 	
			printf("\n The value of cell [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->v);
			printf("\n The mark of cell [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->m);
			if (aux->n->u != NULL && aux->n->u->i != 0)
				printf("\n The up of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->u->v);
			if (aux->n->d != NULL)	
				printf("\n The down of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->d->v);
			if (aux->n->n != NULL)
				printf("\n The next of [%d,%d] is %d",aux->n->i, aux->n->j, aux->n->n->v);
			if (aux->n->p != NULL && aux->n->p->j != 0)
				printf("\n The previous of [%d,%d] is %d\n",aux->n->i, aux->n->j, aux->n->p->v);
            else 
                printf("\n");
			aux=aux->n;
		}
	}
}

	
void delete1(int N, np R[])
{
	int row, column;
	
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
		
		if (temp->n !=NULL)
		{
			temp->n->p=aux;
		}
		
		free(temp);
		printf("\n The cell [%d,%d] has been deleted\n",row,column);
	}
}


void create(np R[], np C[], int N)
{
    int key,l;
    np passkey;
    
    root=NULL;
	
	for (l=1;l<=N;l++)
	{
		aux=R[l];
		while (aux->n!=NULL)
		{ 	
			aux->m=0;
			aux=aux->n;
		}
	}
    
    
    do{
        printf("\n Please enter the key of the node, which you want to make the root\n");
        scanf("%d",&key);
        
        find(R, R[0], key);
        root=aux;
        printf("\n The root is the node with key %d\n",root->i);
        
        if (root == NULL)
            printf("\n Please try again\n");
        
    }while (root == NULL);
    
    mark(R, C, root);
    while (h != NULL)
    {
		find(R, R[0], h->v);
		passkey=aux;
		mark(R, C, passkey);
	}
}


void find(np R[], np rox, int key)
{
	if (rox->d != NULL && rox->d->i != key)
	{
		rox=rox->d;
        find(R, rox, key);
	}
	else if (rox->d != NULL && rox->d->i == key)
	{
		aux=rox->d;
	}
	else if (rox->d == NULL)
	{
		printf("\n The key you entered does not exist\n");
	}
}


void mark(np R[], np C[], np nox)
{
	np fox;
	
	if (nox == root) 
	{
		nox->m=1;
		fox=nox;
		fox->a=nox;
		while (fox->n != NULL)
		{
			fox=fox->n;
			if (R[fox->j]->m != 1)
			{
				push(fox->j);////
				R[fox->j]->a=nox;
				R[fox->j]->m=1;////////////////
			}
			else if (R[fox->j]->m == 1)
			{
				fox->m=2;
			}
		}
		printf("\n%d\n",nox->i);
		printf("\t The ancestor of the node is %d\n", nox->a->i);
	}
	else if (nox != root)
	{
		//nox->m=1;
		fox=nox;
		while (fox->n != NULL)
		{
			fox=fox->n;
			if (R[fox->j]->m != 1)
			{
				push(fox->j);////
				R[fox->j]->a=nox;
				R[fox->j]->m=1;////////////////
			}
			else if (R[fox->j]->m == 1)
			{
				if (fox->j != R[fox->i]->a->i)
					fox->m=2;
			}
		}
		printf("\n%d\n",nox->i);
		printf("\t The ancestor of the node is %d\n", nox->a->i);
		pop(nox->i);
	}
}


void push(int key)
{ 
	np rox;
	
	temp=(np)malloc(sizeof(struct node));
	
	temp->v=key;
	temp->n=NULL;
	temp->p=NULL;
	
	if (h != NULL)
	{	
		rox=h;
		while(rox->n!=NULL)
			{	rox=rox->n;}
		temp->p=rox;
		rox->n=temp;
		if (rox == t) 
			t=temp;
	}
	if(h == NULL)
	{
		h=temp;
		h->n=NULL;
		h->p=NULL;
		t=temp;
	}
}



void pop(int key) 
{
	np rip;
	
    if(h != NULL) 
    {	
		if (h->v == key)
		{
			if (h->n != NULL)
			{
				rip=h;
				h=h->n;
				h->p=NULL;
				free(rip);
			}
			else if (h->n == NULL)
			{
				rip=h;
				h=NULL;
				t=NULL;
				free(rip);
			}
		}
	}
}
