#include<stdio.h>
#include<stdlib.h>

typedef struct node *tp;

struct node
{	int k;
    char cl;
    tp p, l, r;
};


void insert_find_space(tp x, tp temp, tp *aux);
void insert_node(tp *root);
void insert_fixup(tp temp, tp *axe, tp *nox, tp *fox);
void print_tree(tp root);
void delete_node(tp *root);
void find_node(tp x,tp* aux,int key);
void exchange_delete_node_a(tp x,tp y,tp *vox);
void delete_fixup(tp x,tp *vox);


int main ()
{
	tp root = NULL;
    char c = '*';
    
    printf("\nThis programme simulates a Red Black Tree\n");

    while (c != 'q')
    {
        printf("\n insert(i), print(p), delete(d), quit(q)\n");
        scanf("\n %c", &c);

        if (c == 'i')
        {
            insert_node(&root);
        }
        else if (c == 'p')
        {
            print_tree(root);
            if (root != NULL)
            {
                printf("\n\n The root is  %d and its colour is  %c\n", root->k, root->cl);
            }
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

    temp = (tp)malloc(sizeof(struct node));

    printf("\n Give me a new key\n");
    scanf("\n %d", &key);

    temp->k = key;
    temp->l = NULL;
    temp->r = NULL;
    temp->p = NULL;
    temp->cl = 'R';

    if (*root == NULL)
    {
        temp->p = temp;
        temp->cl = 'B';
        *root = temp;
     
        printf("\n The root now is %d\n", (*root)->k);
    }
    else if (*root != NULL)
    {
        temp->p = *root;
        insert_find_space(*root, temp, &(*root));
    }
    
    temp=NULL;
    free(temp);
}


void insert_find_space(tp x, tp temp, tp *aux)
{
	tp  nox=NULL, fox=NULL;
    
    if ((x->k > temp->k) && (x->l!=NULL))
    {
        insert_find_space(x->l,temp,&(*aux));
    }
    else if ((x->k > temp->k) && (x->l==NULL))
    {
        x->l=temp;
        x->l->p=x;
        printf("\n The  l of %d is %d\n",x->k,x->l->k);
        insert_fixup(x->l,&(*aux),&nox,&fox);
        while (fox!=nox)
        {
            insert_fixup(nox,&(*aux),&nox,&fox);
        }
    }
    
    if ((x->k < temp->k) && (x->r!=NULL))
    {
        insert_find_space(x->r,temp,&(*aux));
    }
    else if ((x->k < temp->k) && (x->r==NULL))
    {
        x->r=temp;
        x->r->p=x;
        printf("\n The  r of %d is  %d\n",x->k,x->r->k);
        insert_fixup(x->r,&(*aux),&nox,&fox);
        
        while (fox!=nox)
        {
            insert_fixup(nox,&(*aux),&nox,&fox);
        }
    }
}

void insert_fixup(tp temp, tp *axe, tp *nox, tp *fox)
{
    if (temp == (*axe))
    {
        temp->cl = 'B';
    }
    
    (*nox)=temp;
    (*fox)=temp;
    
    if ((temp->p->p->l!=NULL) && (temp->p->p->l->cl=='R') && temp!=(*axe) && temp->p->cl=='R')
    {
        if (((temp->p->p->l!=temp->p) && (temp->p->p->l->cl=='R')) && (temp->p!=(*axe)))
        {
            temp->p->p->l->cl='B';
            temp->p->p->r->cl='B';
            temp->p->p->cl='R';
            
            if (temp->p->p==(*axe))
            {
                (*axe)->cl='B';
            }
        }
    }
    
    if ((temp->p->p->r!=NULL) && (temp->p->p->r->cl=='R') && temp!=(*axe) && temp->p->cl=='R')
    {
        if (((temp->p->p->r!=temp->p) && (temp->p->p->r->cl=='R')) && (temp->p!=(*axe))) 
        {
            temp->p->p->l->cl='B';
            temp->p->p->r->cl='B';
            temp->p->p->cl='R';
            
            if (temp->p->p==(*axe))
            {
                (*axe)->cl='B';
            }
        }
        
    }
    
    if (temp->p->p->r==NULL)
    {
        if ((temp->p->p->l==temp->p) && (temp->p->l==temp) && temp->p->cl=='R')
        {
            temp->p->p->l=temp->p->r;
            temp->p->r=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->r->p=temp->p;
            if (temp->p->r->l!=NULL)
                temp->p->r->l->p=temp->p->r;
            
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            
            if (temp->p->r==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->r->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->r->k)
                    temp->p->p->l=temp->p;
            }
        }
        
        if ((temp->p->p->l==temp->p) && (temp->p->r==temp) && temp->p->cl=='R')
        {
            temp->p->r=temp->l;
            temp->l=temp->p;
            temp->p->p->l=temp;
            temp->p=temp->p->p;
            temp->l->p=temp;
            temp=temp->l;
            
            if (temp->r!=NULL)
                temp->r->p=temp;
            
            temp->p->p->l=temp->p->r;
            temp->p->r=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->r->p=temp->p;
            if (temp->p->r->l!=NULL)
                temp->p->r->l->p=temp->p->r;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            
            if (temp->p->r==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->r->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->r->k)
                    temp->p->p->l=temp->p;
            }
        }
    } 
    else if ((temp->p->p->r!=NULL) && (temp->p->p->r->cl=='B'))
    {
        if ((temp->p->p->l==temp->p) && (temp->p->l==temp) && temp->p->cl=='R')
        {
            temp->p->p->l=temp->p->r;
            temp->p->r=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->r->p=temp->p;
            if (temp->p->r->l!=NULL)
                temp->p->r->l->p=temp->p->r;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            temp->p->r->r->cl='B';
            
            if (temp->p->r==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->r->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->r->k)
                    temp->p->p->l=temp->p;
            }
        }
        
        if ((temp->p->p->l==temp->p) && (temp->p->r==temp) && temp->p->cl=='R')
        {
            temp->p->r=temp->l;
            temp->l=temp->p;
            temp->p->p->l=temp;
            temp->p=temp->p->p;
            temp->l->p=temp;
            temp=temp->l;
            
            if (temp->r!=NULL)
                temp->r->p=temp;
            
            temp->p->p->l=temp->p->r;
            temp->p->r=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->r->p=temp->p;
            if (temp->p->r->l!=NULL)
                temp->p->r->l->p=temp->p->r;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            temp->p->r->r->cl='B';
            
            if (temp->p->r==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->r->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->r->k)
                    temp->p->p->l=temp->p;
            }
        }
    }  
    else if (temp->p->p->l==NULL)
    {
        if ((temp->p->p->r==temp->p) && (temp->p->r==temp) && temp->p->cl=='R')
        {
            temp->p->p->r=temp->p->l;
            temp->p->l=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->l->p=temp->p;
            if (temp->p->l->r!=NULL)
                temp->p->l->r->p=temp->p->l;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            
            if (temp->p->l==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->l->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->l->k)
                    temp->p->p->l=temp->p;
            }
        }
        
        if ((temp->p->p->r==temp->p) && (temp->p->l==temp) && temp->p->cl=='R')
        {
            temp->p->l=temp->r;
            temp->r=temp->p;
            temp->p->p->r=temp;
            temp->p=temp->p->p;
            temp->r->p=temp;
            temp=temp->r;
            
            if (temp->l!=NULL)
                temp->l->p=temp;
            
            temp->p->p->r=temp->p->l;
            temp->p->l=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->l->p=temp->p;
            if (temp->p->l->r!=NULL)
                temp->p->l->r->p=temp->p->l;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            
            if (temp->p->l==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->l->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->l->k)
                    temp->p->p->l=temp->p;
            }
        }
    }  
    else if ((temp->p->p->l!=NULL) && (temp->p->p->l->cl=='B'))    
    {
        if ((temp->p->p->r==temp->p) && (temp->p->r==temp) && temp->p->cl=='R')
        {
            temp->p->p->r=temp->p->l;
            temp->p->l=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->l->p=temp->p;
            if (temp->p->l->r!=NULL)
                temp->p->l->r->p=temp->p->l;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            temp->p->l->l->cl='B';
            
            if (temp->p->l==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
                if (temp->p->p->k<temp->p->l->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->l->k)
                    temp->p->p->l=temp->p;
            }
        }
        
        if ((temp->p->p->r==temp->p) && (temp->p->l==temp) && temp->p->cl=='R')
        {
            temp->p->l=temp->r;
            temp->r=temp->p;
            temp->p->p->r=temp;
            temp->p=temp->p->p;
            temp->r->p=temp;
            temp=temp->r;
            
            if (temp->l!=NULL)
                temp->l->p=temp;
            
            temp->p->p->r=temp->p->l;
            temp->p->l=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->l->p=temp->p;
            if (temp->p->l->r!=NULL)
                temp->p->l->r->p=temp->p->l;
            temp->p->l->cl='R';
            temp->p->r->cl='R';
            temp->p->cl='B';
            temp->p->l->l->cl='B';
            
            if (temp->p->l==(*axe))
            {
                temp->p->p=temp->p;
                (*axe)=temp->p;
                (*axe)->cl='B';
            }
            if (temp->p!=(*axe))
            {
            if (temp->p->p->k<temp->p->l->k)
                temp->p->p->r=temp->p;
            if (temp->p->p->k>temp->p->l->k)
                temp->p->p->l=temp->p;
            }
        }
    }  
    
    if (temp->p->p->cl=='R' && temp->p->p->p->cl=='R')
    {    
        (*nox)=temp->p->p;
    }
    
}



void print_tree(tp x)
{
    if (x != NULL)
    {
        if (x->l != NULL)
        {
            print_tree(x->l);
        }
        printf("\n the key is  %d, its colour is %c and its parent is %d", x->k, x->cl, x->p->k);
        if (x->r != NULL)
        {
            print_tree(x->r);
        }
    }
    else if (x == NULL)
    {
        printf("\n There are no nodes to print\n");
    }
}

void delete_node(tp *root)
{
    tp rox, axe, vox;
    int key;
    
    vox=(*root);
    
    if (*root==NULL)
    {
        printf("\n There are no nodes to delete!\n");
    }
    
    if (*root!=NULL)
    {
        printf("\n Give me the key of the node you want to delete\n");
        scanf("\n%d",&key);
        rox=NULL;
        axe=NULL;
        
        find_node(*root,&rox,key);
        
        while (rox==NULL)
        {
            printf("\n \n \nThe availiable keys are :\n");
            print_tree(*root);
            printf("\n Plz type a key that exists and it is a number\n otherwise it will make an infinite loop\n");
            scanf("\n%d",&key);
            find_node(*root,&rox,key);
        }
        
        printf("\n The node with the key %d ",rox->k);
        
        if ((rox!=*root) && (rox->l==NULL) && (rox->r==NULL))
        {
            if ((rox->p->l!=NULL) && (rox->p->l->k==rox->k))
            {
                delete_fixup(rox,&vox);
                rox->p->l=NULL;
                (*root)=vox;
                free(rox);
            }
            else if ((rox->p->r!=NULL) && (rox->p->r->k==rox->k))
            {
                delete_fixup(rox,&vox);
                rox->p->r=NULL;
                (*root)=vox;
                free(rox); 
            }
        }
        else if ((rox==*root) && (rox->l==NULL) && (rox->r==NULL))
        {
            free(rox);
            *root=NULL;
        }
        
        else if ((rox==*root) && (rox->l==NULL) && (rox->r!=NULL))
        {
            delete_fixup(rox,&vox);
            rox->r->p=rox->r;
            *root=rox->r;
            free(rox);
        }
        else if ((rox==*root) && (rox->l!=NULL) && (rox->r==NULL))
        {
            delete_fixup(rox,&vox);
            rox->l->p=rox->l;
            *root=rox->l;
            free(rox);
        }
        else if ((rox!=*root) && (rox->l!=NULL) && (rox->r==NULL))
        {
            if (rox->p->r==rox)
            {
                rox->p->r=rox->l;
                rox->l->p=rox->p;
            }
            else if (rox->p->l==rox)
            {
                rox->p->l=rox->l;
                rox->l->p=rox->p;
            }
            delete_fixup(rox->l,&vox);
            (*root)=vox;
            free(rox);
        }
        else if ((rox!=*root) && (rox->l==NULL) && (rox->r!=NULL))
        {
            if (rox->p->l==rox)
            {
                rox->p->l=rox->r;
                rox->r->p=rox->p;
            }
            else if (rox->p->r==rox)
            {
                rox->p->r=rox->r;
                rox->r->p=rox->p;
            }
            delete_fixup(rox->r,&vox);
            (*root)=vox;
            free(rox);
        }
        else if ((rox==*root) ||(rox!=*root) && (rox->l!=NULL) && (rox->r!=NULL))
        {
            axe=rox->l;
            while (axe!=NULL)
            {
                exchange_delete_node_a(axe,rox,&vox);
                axe=axe->r;
            }
        }
        
        printf("has been deleted\n");
    }
}

void find_node(tp x,tp* rox,int key)
{
    if ((x->k!=key) && (x->l!=NULL))
    {
        find_node(x->l,rox,key);
    }
    
    if (x->k==key)
    {
        *rox=x;
    }
    
    if ((x->k!=key) && (x->r!=NULL))
    {
        find_node(x->r,rox,key);
    }
}

void exchange_delete_node_a(tp x,tp y,tp *vox)
{
	tp axe;

    axe = (tp)malloc(sizeof(struct node));
    
    if ((x->r==NULL) && (x->l==NULL))
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
        axe=NULL;
        free(axe);
        free(x);
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
        delete_fixup(x->l,&(*vox));
        axe=NULL;
        free(axe);
        free(x);
    }
}

void delete_fixup(tp x,tp *vox)
{
    tp temp;
    
    if (x->cl=='R' && x->p->cl=='B')
    {
        x->cl='B';
        x->p->cl='B';
    }
    else if (x->cl=='B' && x==(*vox))
    {
        if (x->r!=NULL)
            x->r->cl='B';
        if (x->l!=NULL)
            x->l->cl='B';
    }
    else if (x->cl=='B' && x->p->cl=='B' && x!=(*vox) && x->p!=(*vox))
    {
        x->cl='D';
    }
    
    if (x->cl=='D' && x->p->cl=='B' && x!=(*vox) && x->p!=(*vox))
    {
        if (x->p->r==x && x->p->l!=NULL && x->p->l->l!=NULL)
        {
            if (x->p->l->cl=='B' && x->p->l->l->cl=='R')
            {
                temp=x->p->l->l;
                temp->p->p->l=temp->p->r;
                temp->p->r=temp->p->p;
                temp->p->p=temp->p->p->p;
                temp->p->r->p=temp->p;
                if (temp->p->r->l!=NULL)
                    temp->p->r->l->p=temp->p->r;
                
                if (temp->p->r==(*vox))
                {
                    temp->p->p=temp->p;
                    (*vox)=temp->p;
                    (*vox)->cl='B';
                }
                if (temp->p!=(*vox))
                {
                    if (temp->p->p->k<temp->p->l->k)
                        temp->p->p->r=temp->p;
                    if (temp->p->p->k>temp->p->l->k)
                        temp->p->p->l=temp->p;
                }
                temp->cl='B';
            }
            else if (x->p->l->cl=='R')
            {
                temp=x->p->l->l;
                temp->p->p->l=temp->p->r;
                temp->p->r=temp->p->p;
                temp->p->p=temp->p->p->p;
                temp->p->r->p=temp->p;
                if (temp->p->r->l!=NULL)
                    temp->p->r->l->p=temp->p->r;
                
                if (temp->p->r==(*vox))
                {
                    temp->p->p=temp->p;
                    (*vox)=temp->p;
                    (*vox)->cl='B';
                }
                if (temp->p!=(*vox))
                {
                    if (temp->p->p->k<temp->p->l->k)
                        temp->p->p->r=temp->p;
                    if (temp->p->p->k>temp->p->l->k)
                        temp->p->p->l=temp->p;
                }
                temp->p->r->cl='B';
                x->p->l->cl='R';
            }
        }
        else if (x->p->r==x && x->p->l!=NULL && x->p->l->r!=NULL && x->p->l->r->cl=='R')
        {
            temp=x->p->l->r;
            temp->p->r=temp->l;
            temp->l=temp->p;
            temp->p->p->l=temp;
            temp->p=temp->p->p;
            temp->l->p=temp;
            temp=temp->l;
            
            if (temp->r!=NULL)
                temp->r->p=temp;
            
            temp->p->p->l=temp->p->r;
            temp->p->r=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->r->p=temp->p;
            if (temp->p->r->l!=NULL)
                temp->p->r->l->p=temp->p->r;
            
            if (temp->p->r==(*vox))
            {
                temp->p->p=temp->p;
                (*vox)=temp->p;
                (*vox)->cl='B';
            }
            if (temp->p!=(*vox))
            {
                if (temp->p->p->k<temp->p->l->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->l->k)
                    temp->p->p->l=temp->p;
            }
            temp->p->cl='B';
        }
        else if (x->p->l==x && x->p->r!=NULL && x->p->r->r!=NULL)
        {
            if (x->p->r->cl=='B' && x->p->r->r->cl=='R')
            {
                temp=x->p->r->r;
                temp->p->p->r=temp->p->l;
                temp->p->l=temp->p->p;
                temp->p->p=temp->p->p->p;
                temp->p->l->p=temp->p;
                if (temp->p->l->r!=NULL)
                    temp->p->l->r->p=temp->p->l;
                
                if (temp->p->l==(*vox))
                {
                    temp->p->p=temp->p;
                    (*vox)=temp->p;
                    (*vox)->cl='B';
                }
                if (temp->p!=(*vox))
                {
                    if (temp->p->p->k<temp->p->l->k)
                        temp->p->p->r=temp->p;
                    if (temp->p->p->k>temp->p->l->k)
                        temp->p->p->l=temp->p;
                }
                temp->cl='B';
            }
            else if (x->p->r->cl=='R')
            {
                temp=x->p->r->r;
                temp->p->p->r=temp->p->l;
                temp->p->l=temp->p->p;
                temp->p->p=temp->p->p->p;
                temp->p->l->p=temp->p;
                if (temp->p->l->r!=NULL)
                    temp->p->l->r->p=temp->p->l;
                
                if (temp->p->l==(*vox))
                {
                    temp->p->p=temp->p;
                    (*vox)=temp->p;
                    (*vox)->cl='B';
                }
                if (temp->p!=(*vox))
                {
                    if (temp->p->p->k<temp->p->l->k)
                        temp->p->p->r=temp->p;
                    if (temp->p->p->k>temp->p->l->k)
                        temp->p->p->l=temp->p;
                }
                temp->p->cl='B';
                x->p->r->cl='R';
            }
        }
        else if (x->p->l==x && x->p->r!=NULL && x->p->r->l!=NULL && x->p->r->l->cl=='R')
        {
            temp=x->p->r->l;
            temp->p->l=temp->r;
            temp->r=temp->p;
            temp->p->p->r=temp;
            temp->p=temp->p->p;
            temp->r->p=temp;
            temp=temp->r;
            
            if (temp->l!=NULL)
                temp->l->p=temp;
            
            temp->p->p->r=temp->p->l;
            temp->p->l=temp->p->p;
            temp->p->p=temp->p->p->p;
            temp->p->l->p=temp->p;
            if (temp->p->l->r!=NULL)
                temp->p->l->r->p=temp->p->l;
            
            if (temp->p->l==(*vox))
            {
                temp->p->p=temp->p;
                (*vox)=temp->p;
                (*vox)->cl='B';
            }
            if (temp->p!=(*vox))
            {
                if (temp->p->p->k<temp->p->l->k)
                    temp->p->p->r=temp->p;
                if (temp->p->p->k>temp->p->l->k)
                    temp->p->p->l=temp->p;
            }
            temp->p->cl='B';
        }
        else if (x->p->r==x && x->p->l!=NULL && x->p->l->l==NULL && x->p->l->r==NULL)
        {
            x->p->cl='D';
            x->p->l->cl='R';
            delete_fixup(x->p,&(*vox));
        }
        else if (x->p->l==x && x->p->r!=NULL && x->p->r->l==NULL && x->p->r->r==NULL)
        {
            x->p->cl='D';
            x->p->r->cl='R';
            delete_fixup(x->p,&(*vox));
        }
    }
    else if (x->cl=='R' && x->p->cl=='R')
    {
        x->p->cl='B';
        x->p->r->cl='R';
        x->p->l->cl='R';
    }
}
