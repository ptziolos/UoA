#include <stdio.h>
#include <stdlib.h>

typedef struct node *np;

struct node
{
	int i,j,v,w,m; 
    np p,n,u,d,a; //previous, next, up, down, ancestor
};

np temp, aux, aux1, aux2, root, h, t, h1, h2, h3, h4;

void insert1(int N, np R[], np C[]);
void print1(int N, np R[]);
void delete1(int N, np R[]);
void find(np R[], np rox, int key);
void create(np R[], np C[], int N);
void push(int key);
void push1(int key);
void push2(int key);
void push3(np edge);
void push4(np edge);
void pop(int key);
void pop1(int key);
void pop2(int key);
void pop3();
void pop4();
void mark(np R[], np C[], np nox);
void cyclehunt(np R[], int N);
void halfcycleprint(np boom, int key, int guard);
void defineroot(np R[], int N);
void Prim(np R[], np nox);
void Kruskal(np R[], int N);


// Menu and definition of the arrays
int main (void)
{
    printf("\nThis programme simulates a Sparce Array\n");
	
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
		C[l]->a=NULL;

		R[l]->j=0;
		R[l]->i=l;
		R[l]->v=0;
		R[l]->w=0;
		R[l]->m=0;
		R[l]->n=NULL;
		R[l]->p=NULL;
		R[l]->u=NULL;
		R[l]->d=NULL;
		R[l]->a=NULL;
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
        printf("\n insert(i),\t print(p),\t delete(d),\t create spanning tree(t),\n\n cycle hunt(c),\t MSTprim(m),\t MSTkruskal(k),\t quit(q)\n\n");
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
		else if (s == 'c')
		{
			printf("\nTHE CYCLE HUNT BEGINS\n");
			cyclehunt(R, N);
		}
		else if (s == 'm')
		{
			printf("\nCREATE MINIMAL SPANNING TREE (PRIM)\n");
			defineroot(R, N);
		}
		else if (s == 'k')
		{
			printf("\nCREATE MINIMAL SPANNING TREE (KRUSKAL)\n");
			Kruskal(R, N);
		}
    }
printf("\nQUIT\n");
return 0;
}


// Insertion of elements and check if the cell already exists and connection of the new cell with 
// its neighboring nodes that reside at the left of it, at the right of it under it and above it -  
// O(k), k is the number of the cells of the horizontal and the vertical arrays
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
	temp->m=0;
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


// Printing of the nodes and its neighbores - O(n), n is the number of 
// the nodes that have been inserted
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
				printf("\n The up of [%d,%d] is [%d,%d]",aux->n->i, aux->n->j, aux->n->u->i, aux->n->u->j);
			if (aux->n->d != NULL)	
				printf("\n The down of [%d,%d] is [%d,%d]",aux->n->i, aux->n->j, aux->n->d->i, aux->n->d->j);
			if (aux->n->n != NULL)
				printf("\n The next of [%d,%d] is [%d,%d]",aux->n->i, aux->n->j, aux->n->n->i, aux->n->n->j);
			if (aux->n->p != NULL && aux->n->p->j != 0)
				printf("\n The previous of [%d,%d] is [%d,%d]\n",aux->n->i, aux->n->j, aux->n->p->i, aux->n->p->j);
            else 
                printf("\n");
			aux=aux->n;
		}
	}
}


// Insertion of the cell which is going to be deleted, detection and deletion of the node - 
// O(k), k is the number of the cells of the horizontal and the vertical arrays
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


// Definition of the root for the Spanning tree and unmarking of the nodes - 
// O(k^2), k is the number of the cells of the horizontal and the vertical arrays
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


// Detection of the node - O(k), k is the number of the cells of the horizontal 
// and the vertical arrays
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


// Marking of the nodes using the BFS method - O(n), n is the number of the nodes that 
// have been inserted
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
				push(fox->j);
				R[fox->j]->a=nox;
				R[fox->j]->m=1;
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
		fox=nox;
		while (fox->n != NULL)
		{
			fox=fox->n;
			if (R[fox->j]->m != 1)
			{
				push(fox->j);
				R[fox->j]->a=nox;
				R[fox->j]->m=1;
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


// Insertion of the nodes in a queue using the BFS method - 
// O(r), r is the number of the nodes in the queue
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


// Insertion of the nodes in a queue - O(r), r is the number of the nodes in the queue
void push1(int key)
{ 
	np rox;
	
	temp=(np)malloc(sizeof(struct node));
	
	temp->v=key;
	temp->n=NULL;
	temp->p=NULL;
	
	if (h1 != NULL)
	{	
		rox=h1;
		while(rox->n!=NULL)
			{	rox=rox->n;}
		temp->p=rox;
		rox->n=temp;
	}
	if(h1 == NULL)
	{
		h1=temp;
		h1->n=NULL;
		h1->p=NULL;
	}
}


// Insertion of the nodes in a queue - O(r), r is the number of the nodes in the queue
void push2(int key)
{ 
	np rox;
	
	temp=(np)malloc(sizeof(struct node));
	
	temp->v=key;
	temp->n=NULL;
	temp->p=NULL;
	
	if (h2 != NULL)
	{	
		rox=h2;
		while(rox->n!=NULL)
			{	rox=rox->n;}
		temp->p=rox;
		rox->n=temp;
	}
	if(h2 == NULL)
	{
		h2=temp;
		h2->n=NULL;
		h2->p=NULL;
	}
}


// Deletion of the first node of the queue - O(1)
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


// Deletion of the first node of the queue - O(1)
void pop1(int key) 
{
	np rip;
	
    if(h1 != NULL) 
    {	
		if (h1->v == key)
		{
			if (h1->n != NULL)
			{
				rip=h1;
				h1=h1->n;
				h1->p=NULL;
				free(rip);
			}
			else if (h1->n == NULL)
			{
				rip=h1;
				h1=NULL;
				free(rip);
			}
		}
	}
}


// Deletion of the first node of the queue - O(1)
void pop2(int key) 
{
	np rip;
	
    if(h2 != NULL) 
    {	
		if (h2->v == key)
		{
			if (h2->n != NULL)
			{
				rip=h2;
				h2=h2->n;
				h2->p=NULL;
				free(rip);
			}
			else if (h2->n == NULL)
			{
				rip=h2;
				h2=NULL;
				free(rip);
			}
		}
	}
}


// Detection of cycles and printing part of them - O(n), n is the number of the nodes 
// that have been inserted
void cyclehunt(np R[], int N)
{
	int l;
	np box, dox, buf;
	
	for (l=1;l<=N;l++)
	{
		buf=NULL;
		aux=R[l];
		while (aux->n!=NULL)
		{ 	
			aux=aux->n;
			if (aux->m == 2)
			{
				box=R[aux->i];
				dox=R[aux->j];
				
				do{
					push1(box->i);
					box=box->a;
				}while (box->i != box->a->i);
				
				do{
					push2(dox->i);
					dox=dox->a;
				}while (dox->i != dox->a->i);
				
				if (box->i == box->a->i && h1->v != box->i)
					push1(box->i);
					
				if (dox->i == dox->a->i && h2->v != dox->i)
					push2(dox->i);
				
				/*
				box=h1;
				printf("\nlist1 : %d",box->v);
				while (box->n != NULL)
				{
					box=box->n;
					printf("\nlist1 : %d",box->v);
				}
				
				dox=h2;
				printf("\nlist2 : %d",dox->v);
				while (dox->n != NULL)
				{
					dox=dox->n;
					printf("\nlist2 : %d",dox->v);
				}
				*/

				printf("\nThe cycle is :  ");
                dox=h2;
                buf=h2;
				while (buf == h2)
				{
					box=h1;
					while (box != NULL && buf != box)  
					{
						if (box->v != dox->v)
							box=box->n;
						else if (box->v == dox->v)
							buf=box;
					}
					
					dox=dox->n;
				}
				
                dox=h2;
                while (dox->n != NULL && dox->v != buf->v)
                {
                    printf("%d",dox->v);
                    printf(" -> ");
                    dox=dox->n;
                }
                
				box=h1;
				halfcycleprint(box, buf->v, box->v);
				
				do{
					pop1(h1->v);
				}while (h1 != NULL);
				
				do{
					pop2(h2->v);
				}while (h2 != NULL);
			}
		}
	}
}


// Printing of the rest of the cycle - O(z), z is the number of the nodes of the rest of the cycle
void halfcycleprint(np boom, int key, int guard)
{	
	if (boom->v != key)
		halfcycleprint(boom->n, key, guard);
    
	printf("%d",boom->v);
	if (boom->v != guard)
		printf(" -> ");
}



void defineroot(np R[], int N)
{
    int key,l;
    np aux3;
	
	for (l=1;l<=N;l++)
	{
		aux3=R[l];
		R[l]->w=l;
		R[l]->m=0;
		R[l]->v=1000000;
		while (aux3->n!=NULL)
		{ 	
			aux3=aux3->n;
			aux3->m=0;
		}
	}
    
    do{
        printf("\n Please enter the key of the node, which you want to make the root\n");
        scanf("%d",&key);
        
        root=R[key];
        printf("\n The root is the node with key %d\n",root->i);
        
        if (root == NULL)
            printf("\n Please try again\n");
        
    }while (root == NULL);
    
    Prim(R, root);
    root->v=0;
    while (h3 != NULL)
    {
		Prim(R, R[h3->j]);
	}
}


void Prim(np R[], np nox)
{
	np fox;
	
	if (nox == root && nox->m != 1) 
	{
		nox->m=1;
		fox=nox;
		fox->a=nox;
		while (fox->n != NULL)
		{
			fox=fox->n;
			if (R[fox->j]->w != R[fox->i]->w)
			{
				push3(fox);
			}
		}
	}
	else if (nox == root && nox->m == 1)
	{
		if (R[h3->j]->w == R[h3->i]->w && h3->j == R[h3->i]->a->i)
		{
			printf("\n%d -> %d\n",h3->i,h3->j);
		}
		pop3();
	}
	else if (nox != root && nox->m != 1)
	{
		nox->m=1;
		fox=nox;
		
		if (R[h3->j]->w != R[h3->i]->w)
		{
			R[h3->j]->v=h3->v;
			R[h3->j]->a=R[h3->i];
			R[h3->j]->w=R[h3->i]->w;
			printf("\n%d -> %d\n",h3->i,h3->j);
		}
		
		pop3();

		while (fox->n != NULL)
		{
			fox=fox->n;
			if (R[fox->j]->w != R[fox->i]->w)
			{
				push3(fox);
			}
			else if (R[fox->j]->w == R[fox->i]->w)
			{
				if (fox->j == R[fox->i]->a->i)
				{
					push3(fox);
				}
			}
		}
	}
	else if (nox != root && nox->m == 1)
	{
		if (R[h3->j]->w == R[h3->i]->w && h3->j == R[h3->i]->a->i)
		{
			printf("\n%d -> %d\n",h3->i,h3->j);
		}
		pop3();
	}
}


void push3(np edge)
{
	np temp3,aux3;
	
	temp3=(np)malloc(sizeof(struct node));

	temp3->v=edge->v;
	temp3->i=edge->i;
	temp3->j=edge->j;
	temp3->n=NULL;
	temp3->p=NULL;
	

	if ((h3!=NULL) && (h3->n!=NULL)&& (temp3->v < h3->v))
	{	
		temp3->n=h3;
		h3->p=temp3;
		h3=temp3;
	}
	else if ((h3 != NULL) && (h3->n != NULL) && (temp3->v >= h3->v))
	{	
		aux3=h3;
		while((aux3->n != NULL) && (aux3->n->v < temp3->v))
			{	aux3=aux3->n;}
		temp3->n=aux3->n;
		temp3->p=aux3;
		aux3->n=temp3;
		if (temp3->n != NULL)
			temp3->n->p=temp3; 
	}
	else if((h3 != NULL) && (h3->n == NULL) && (temp3->v >= h3->v))
	{
		h3->n=temp3;
	}
	else if((h3 != NULL) && (h3->n == NULL) && (temp3->v < h3->v))
	{
		temp3->n=h3;
		h3=temp3;
		h3->n->p=h3;
	}
	else if(h3 == NULL)
	{
		h3=temp3;
		h3->n=NULL;
		h3->p=NULL;
	}
}


void pop3()
{
	np rip;
	
    if(h3 != NULL) 
    {	
		if (h3->n != NULL)
		{
			rip=h3;
			h3=h3->n;
			h3->p=NULL;
			free(rip);
		}
		else if (h3->n == NULL)
		{
			rip=h3;
			h3=NULL;
			free(rip);
		}
	}
}


void Kruskal(np R[], int N)
{
    int l,rox;
	np aux4;
    
    for (l=1;l<=N;l++)
	{
		R[l]->w=l;
		R[l]->m=0;
		aux4=R[l];
		while (aux4->n!=NULL)
		{ 	
			aux4=aux4->n;
			aux4->m=0;
			push4(aux4);
		}
	}
	
	while (h4 != NULL)
	{
		if (R[h4->j]->w != R[h4->i]->w)
		{	
			R[h4->j]->a=R[h4->i];
			printf("\n%d -> %d",h4->i,h4->j);
			if (h4 != NULL && R[h4->j]->w > R[h4->i]->w)
			{
				rox=R[h4->j]->w;
				for (l=1;l<=N;l++)
				{
					if (R[l]->w == rox)
					{
						R[l]->w=R[h4->i]->w;
					}
				}
			}
			else if (h4 != NULL && R[h4->j]->w < R[h4->i]->w)
			{
				rox=R[h4->i]->w;
				for (l=1;l<=N;l++)
				{
					if (R[l]->w == rox)
					{
						R[l]->w=R[h4->j]->w;
					}
				}
			}
			pop4();
		}
		else if (R[h4->j]->w == R[h4->i]->w && R[h4->i]->a != NULL && h4->j == R[h4->i]->a->i)
		{
			printf("\n%d -> %d",h4->i,h4->j);
			pop4();
		}
		else
		{
			pop4();
		}
	}
	/*printf("\n\n");
	for (l=1;l<=N;l++)
	{
		printf("\n%d ---> %d",R[l]->i,R[l]->w);
	}*/
}


void push4(np edge)
{
	np temp4,aux4;
	int key;
	
	temp4=(np)malloc(sizeof(struct node));

	temp4->v=edge->v;
	temp4->i=edge->i;
	temp4->j=edge->j;
	temp4->n=NULL;
	temp4->p=NULL;
	

	if ((h4!=NULL) && (h4->n!=NULL) && (temp4->v < h4->v))
	{	
		temp4->n=h4;
		h4->p=temp4;
		h4=temp4;
	}
	else if ((h4 != NULL) && (h4->n != NULL) && (temp4->v == h4->v))
	{
		if ((temp4->i == h4->j) && (temp4->j == h4->i))
		{
			temp4->n=h4->n;
			temp4->p=h4;
			h4->n=temp4;
		}
		else if ((temp4->i != h4->j) || (temp4->j != h4->i))
		{
			aux4=h4;
			while((aux4->n != NULL) && (aux4->n->v == temp4->v) && ((temp4->i != aux4->j) || (temp4->j != aux4->i)))
				{	aux4=aux4->n;}
			temp4->n=aux4->n;
			temp4->p=aux4;
			aux4->n=temp4;
			if (temp4->n != NULL)
				temp4->n->p=temp4; 
		}
	}
	else if ((h4 != NULL) && (h4->n != NULL) && (temp4->v > h4->v))
	{	
		aux4=h4;
		while((aux4->n != NULL) && (aux4->n->v < temp4->v))
			{	aux4=aux4->n;}
		temp4->n=aux4->n;
		temp4->p=aux4;
		aux4->n=temp4;
		if (temp4->n != NULL)
			temp4->n->p=temp4; 
	}
	else if((h4 != NULL) && (h4->n == NULL) && (temp4->v >= h4->v))
	{
		h4->n=temp4;
	}
	else if((h4 != NULL) && (h4->n == NULL) && (temp4->v < h4->v))
	{
		temp4->n=h4;
		h4=temp4;
		h4->n->p=h4;
	}
	else if(h4 == NULL)
	{
		h4=temp4;
		h4->n=NULL;
		h4->p=NULL;
	}
}


void pop4()
{
	np rip;
	
    if(h4 != NULL) 
    {	
		if (h4->n != NULL)
		{
			rip=h4;
			h4=h4->n;
			h4->p=NULL;
			free(rip);
		}
		else if (h4->n == NULL)
		{
			rip=h4;
			h4=NULL;
			free(rip);
		}
	}
}

