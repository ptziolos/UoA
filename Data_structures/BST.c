#include<stdio.h>
#include<stdlib.h>

typedef struct node *tp;
    
	struct node
	{	int k;
		tp p,l,r;
    };

tp root,temp,aux,axe;

void insert_find_space(tp x,tp temp);
void insert_node(tp *root);
void print_tree(tp root);
void delete_node(tp *root);
void find_node(tp x,tp* aux,int key);
void exchange_delete_node_a(tp x,tp y,tp axe);

    
int main ()
{
    char c='*';
    root=NULL;
    printf("\nThis programme simulates a Binary Search Tree\n");
    
    while (c!='q')
    {
        printf("\n insert(i), print(p), delete(d), quit(q)\n");
        scanf("\n %c",&c);
        
        if (c=='i')
        {
            insert_node(&root);
        }
        else if (c=='p')
        {
            print_tree(root);
        }
        else if (c=='d')
        {
            delete_node(&root);
        }
    }
    
    return 0;
    
}


void insert_node(tp *root)
{
    tp temp;
    int key;
    
    temp=(tp)malloc(sizeof(struct node));
    
    printf("\n Give me a new key\n");
    scanf("\n %d",&key);
    
    temp->k=key;
    temp->l=NULL;
    temp->r=NULL;
    temp->p=NULL;
    
    
    printf("\n The k of temp is :%d \n",temp->k);
    
    if (*root==NULL)
    {
        temp->p=temp;
        *root=temp;
        
        printf("\n The root now is %d\n",(*root)->k);
        printf("\n The p is : %d\n",(*root)->p->k);
        
    }
    else if (*root!=NULL) 
    {
        temp->p=*root;
        insert_find_space(*root,temp);
        printf("\n The next node is : %d\n",temp->k);
    }
    
}
    

void insert_find_space(tp x,tp temp)
{
    
    if ((x->k > temp->k) && (x->l!=NULL))
    {
        insert_find_space(x->l,temp);
    }
    else if ((x->k > temp->k) && (x->l==NULL))
    {
        
        x->l=temp;
        x->l->p=x;
        printf("\n The  l is : %d\n",x->l->k);
        printf("\n The  parent of l is : %d\n",x->l->p->k);
    }
    
    if ((x->k < temp->k) && (x->r!=NULL))
    {
        insert_find_space(x->r,temp);
    }
    else if ((x->k < temp->k) && (x->r==NULL))
    {
        x->r=temp;
        x->r->p=x;
        printf("\n The  r is : %d\n",x->r->k);
        printf("\n The  parent of r  is : %d\n",x->r->p->k);
    }
}
    
void print_tree(tp x)
{
    if (x!=NULL)
    {
        if (x->l!=NULL)
        {
            print_tree(x->l);
        }
        printf("\n the key is :%d\n",x->k);
        if (x->r!=NULL)
        {
            print_tree(x->r);
        }
    }
    else if (x==NULL)
    {
        printf("\n There are no nodes to print\n");
    }
}

void delete_node(tp *root)
{
    tp aux,axe;
    int key;
    
    if (*root==NULL)
    {
        printf("\n There are no nodes to delete!\n");
    }
    
    if (*root!=NULL)
    {
        printf("\n Give me the key of the node you want to delete\n");
        scanf("\n%d",&key);
        aux=NULL;
        axe=NULL;
        
        find_node(*root,&aux,key);
        
        while (aux==NULL)
        {
            printf("\n \n \nThe availiable keys are :\n");
            print_tree(*root);
            printf("\n Plz type a key that exists and it is a number\n otherwise it will make an infinite loop\n");
            scanf("\n%d",&key);
            find_node(*root,&aux,key);
        }
        
        printf("\n The node with the key %d ",aux->k);
        
        if ((aux!=*root) && (aux->l==NULL) && (aux->r==NULL))
        {
            if ((aux->p->l!=NULL) && (aux->p->l->k==aux->k))
            {
                aux->p->l=NULL;
                free(aux);
            }
            else if ((aux->p->r!=NULL) && (aux->p->r->k=aux->k))
            {
                aux->p->r=NULL;
                free(aux); 
            }
        }
        else if ((aux==*root) && (aux->l==NULL) && (aux->r==NULL))
        {
            free(aux);
            *root=NULL;
        }
        else if ((aux!=*root) && (aux->l==NULL) && (aux->r!=NULL))
        {
            if (aux->p->l==aux)
            {
                aux->p->l=aux->r;
                aux->r->p=aux->p;
            }
            else if (aux->p->r==aux)
            {
                aux->p->r=aux->r;
                aux->r->p=aux->p;
            }
            free(aux);
        }
        else if ((aux==*root) && (aux->l==NULL) && (aux->r!=NULL))
        {
            aux->r->p=aux->r;
            *root=aux->r;
            free(aux);
        }
        else if ((aux!=*root) && (aux->l!=NULL) && (aux->r==NULL))
        {
            if (aux->p->r==aux)
            {
                aux->p->r=aux->l;
                aux->l->p=aux->p;
            }
            else if (aux->p->l==aux)
            {
                aux->p->l=aux->l;
                aux->l->p=aux->p;
            }
            free(aux);
        }
        else if ((aux==*root) && (aux->l!=NULL) && (aux->r==NULL))
        {
            aux->l->p=aux->l;
            *root=aux->l;
            free(aux);
        }
        else if ((aux==*root) ||(aux!=*root) && (aux->l!=NULL) && (aux->r!=NULL))
        {
            exchange_delete_node_a(aux->l,aux,&axe);
        }
        
        printf("has been deleted\n");
    }
}

void find_node(tp x,tp* aux,int key)
{
    if ((x->k!=key) && (x->l!=NULL))
    {
        find_node(x->l,aux,key);
    }
    
    if (x->k==key)
    {
        *aux=x;
    }
    
    if ((x->k!=key) && (x->r!=NULL))
    {
        find_node(x->r,aux,key);
    }
}

void exchange_delete_node_a(tp x,tp y,tp axe)
{
    if (x->r!=NULL)
    {
        exchange_delete_node_a(x->r,y,axe);
    }
    else if ((x->r==NULL) && (x->l==NULL))
    {
        axe->k=y->k;
        axe->l=y->l;
        y->k=x->k;
        x->k=axe->k;
        
        if (x->p->r!=x)
        {
            y->l=NULL;
        }
        else if (x->p->r==x)
        {
            x->p->r=NULL;
        }
        axe=x;
        free(axe);
    }
    else if ((x->r==NULL) && (x->l!=NULL))
    {
        axe->k=y->k;
        axe->l=y->l;
        y->k=x->k;
        x->k=axe->k;
        
        if (x->p->r!=x)
        {
            y->l=NULL;
            x->p->l=x->l;
            x->l->p=x->p;
        }
        else if (x->p->r==x)
        {
            x->p->r=x->l;
            x->l->p=x->p;
        }
        axe=x;
        free(axe);
    }
}