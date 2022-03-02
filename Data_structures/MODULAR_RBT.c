#include<stdio.h>
#include<stdlib.h>

typedef struct node *tp;
typedef struct Integer *ip;
typedef struct Double *dp;
typedef struct Character *cp;

struct node
{	void *k;
    char cl;
    tp p, l, r;
};

struct Integer
{
	int i;
};

struct Double
{
	double d;
};

struct Character
{
	char c[10];
};


void insert_find_space(tp x, tp temp, tp *aux, int s);
void insert_node(tp *root, int s);
void insert_fixup(tp temp, tp *axe, tp *nox, tp *fox);
void print_root(tp x, int s);
void print_tree(tp x, int s);
void delete_node(tp *root, int s);
void find_node(tp x,tp* aux,void *key,int s);
void exchange_delete_node_a(tp x,tp y,tp *vox);
void delete_fixup(tp x,tp *vox);
int compare(void *super,void *duper,int s);
void delete_message(tp rox, int s);


int main ()
{
	tp rooti = NULL, rootd=NULL, rootc = NULL;
    char c = '*';
    int s;
    printf("\nThis programme simulates a Red Black Tree\n");

    while (c != 'q')
    {
    	fflush(stdin);
        printf("\n\n insert(i), print(p), delete(d), quit(q)\n");
        printf("\n Your choice is ");
        scanf("\n %c", &c);

        if (c == 'i')
        {
        	printf("\n INTEGER (1),  DOUBLE (2),  STRING (3) \n");
        	printf("\n Your TYPE choice is ");
        	scanf("\n %d", &s);
        	
        	if (s == 1)
        	{
        		insert_node(&rooti,s);
			}
			else if (s == 2)
			{
				insert_node(&rootd,s);
			}
			else if (s == 3)
			{
				insert_node(&rootc,s);
			}    
        }
        else if (c == 'p')
        {
        	printf("\n INTEGER (1),  DOUBLE (2),  STRING (3) \n");
        	printf("\n Your TYPE choice is ");
        	scanf("\n %d", &s);
        	
        	if (s == 1)
        	{
        		print_root(rooti,s);
        		print_tree(rooti,s);
			}
			else if (s == 2)
			{
				print_root(rootd,s);
				print_tree(rootd,s);
			}
			else if (s == 3)
			{
				print_root(rootc,s);
				print_tree(rootc,s);
			}
        }
        else if (c == 'd')
        {
    		printf("\n INTEGER (1),  DOUBLE (2),  STRING (3) \n");
        	printf("\n Your TYPE choice is ");
        	scanf("\n %d", &s);
        	
        	if (s == 1)
        	{
        		delete_node(&rooti,s);
			}
			else if (s == 2)
			{
				delete_node(&rootd,s);
			}
			else if (s == 3)
			{
				delete_node(&rootc,s);
			}    
		}
    }

    return 0;

}


int compare(void *super,void *duper,int s)
{
	if (s == 1)
	{
		if (*(int*)super > *(int*)duper)
		{
			return 1;
		}
		else if (*(int*)super < *(int*)duper)
		{
			return -1;
		}
		else if (*(int*)super == *(int*)duper)
		{
			return 0;
		}
	}
	else if (s == 2)
	{
		if (*(double*)super > *(double*)duper)
		{
			return 1;
		}
		else if (*(double*)super < *(double*)duper)
		{
			return -1;
		}
		else if (*(double*)super == *(double*)duper)
		{
			return 0;
		}
	}
	else if (s == 3)
	{
		return (strcmp((char *)super, (char *)duper));
	}
}


void insert_node(tp *root, int s)
{
	fflush(stdin);
	
	ip ikey;
	dp dkey;
	cp ckey;
    tp temp;
    

    temp = (tp)malloc(sizeof(struct node));
    
	temp->l = NULL;
	temp->r = NULL;
	temp->p = NULL;
	temp->cl = 'R';
	    
	if (s == 1)
	{
		ikey = (ip)malloc(sizeof(struct Integer));
		printf("\n key = ");
		scanf("%d",&(ikey->i));
		temp->k = ikey;
	}
	else if (s == 2)
	{
		dkey = (dp)malloc(sizeof(struct Double));
		printf("\n key = ");
		scanf("%lf",&(dkey->d));
		temp->k = dkey;
	}
	else if (s == 3)
	{
		ckey = (cp)malloc(sizeof(struct Character));
		printf("\n key = ");
		fgets((ckey->c),10,stdin);
		temp->k = ckey;
	}
	

    if (*root == NULL)
    {
        temp->p = temp;
        temp->cl = 'B';
        *root = temp;
    }
    else if (*root != NULL)
    {
        temp->p = *root;
        insert_find_space(*root, temp, &(*root),s);
    }
    
    temp=NULL;
    free(temp);
    
	if (s == 1)
	{
		ikey=NULL;
		free(ikey);
	}
	else if (s == 2)
	{
		dkey=NULL;
		free(dkey);
	}
	else if (s == 3)
	{
		ckey=NULL;
		free(ckey);
	}
}


void insert_find_space(tp x, tp temp, tp *aux, int s)
{
	tp  nox=NULL, fox=NULL;
    
    if  ((compare(x->k,temp->k,s) > 0) && (x->l != NULL)) // ((x->k > temp->k) && (x->l!=NULL))
    {
        insert_find_space(x->l,temp,&(*aux),s);
    }
    else if  ((compare(x->k,temp->k,s) > 0) && (x->l == NULL)) // ((x->k > temp->k) && (x->l==NULL))
    {
        x->l=temp;
        x->l->p=x;
        
        insert_fixup(x->l,&(*aux),&nox,&fox);
        while (fox != nox)
        {
            insert_fixup(nox,&(*aux),&nox,&fox);
        }
    }
    
    if ((compare(x->k,temp->k,s) < 0) && (x->r != NULL)) // ((x->k < temp->k) && (x->r!=NULL))
    {
        insert_find_space(x->r,temp,&(*aux),s);
    }
    else if ((compare(x->k,temp->k,s) < 0) && (x->r == NULL)) // ((x->k < temp->k) && (x->r==NULL))
    {
        x->r=temp;
        x->r->p=x;
		
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


void print_root(tp x, int s)
{
	int i;
	
	if (x!= NULL)
    {
    	if (s == 1)
        {
        	printf("\n\n The root is  %d \n", *(int *)(x->k));	
		}
		else if (s == 2)
		{
			printf("\n\n The root is  %lf \n", *(double *)(x->k));
		}
		else if (s == 3)
		{
			i=1;
			printf("\n\n The root is  ");
			while (*(char *)(x->k+i) != '\0')
			{
				printf("%c", *(char *)(x->k+i-1));
				i=i+1;
			}
		}
    }
}

void print_tree(tp x, int s)
{
	int i,j;
	
    if (x != NULL)
    {
        if (x->l != NULL)
        {
            print_tree(x->l,s);
        }
        if (s == 1)
        {
        	printf("\n the key is  %d, its colour is %c and its parent is %d",*(int *)(x->k), x->cl, *(int *)(x->p->k));	
		}
		else if (s == 2)
		{
			printf("\n the key is  %lf, its colour is %c and its parent is %lf",*(double *)(x->k), x->cl, *(double *)(x->p->k));
		}
		else if (s == 3)
		{
			i=1;
			printf("\n\n The key is  ");
			while (*(char *)(x->k+i) != '\0')
			{
				printf("%c", *(char *)(x->k+i-1));
				i=i+1;
			}
			printf(", its colour is  %c ",x->cl);
			
			j=1;
			printf(" and its parent is  ");
			while (*(char *)(x->p->k+j) != '\0')
			{
				printf("%c", *(char *)(x->p->k+j-1));
				j=j+1;
			}
		}
        if (x->r != NULL)
        {
            print_tree(x->r,s);
        }
    }
    else if (x == NULL)
    {
        printf("\n There are no nodes to print\n");
    }
}

void delete_node(tp *root, int s)
{
	fflush(stdin);
	
	int l;
    tp rox, axe, vox;
    ip ikey;
    dp dkey;
    cp ckey;
    
    vox=(*root);
    
    if (*root==NULL)
    {
        printf("\n There are no nodes to delete!\n");
    }
    
    if (*root!=NULL)
    {
        printf("\n The key to be deleted is ");
        
        if (s == 1)
		{
			ikey = (ip)malloc(sizeof(struct Integer));
			scanf("%d",&(ikey->i));
		}
		else if (s == 2)
		{
			dkey = (dp)malloc(sizeof(struct Double));
			scanf("%lf",&(dkey->d));
		}
		else if (s == 3)
		{
			ckey = (cp)malloc(sizeof(struct Character));
			fgets((ckey->c),10,stdin);
		}
        
        rox=NULL;
        axe=NULL;
        
        if (s == 1)
		{
			find_node(*root,&rox,ikey,s);
		}
		else if (s == 2)
		{
			find_node(*root,&rox,dkey,s);
		}
		else if (s == 3)
		{
			find_node(*root,&rox,ckey,s);
		}
        
        if (rox==NULL)
        {
        	if (s == 1)
			{
				printf("\n The node with key %d does not exist",*(int *)ikey);
			}
			else if (s == 2)
			{
				printf("\n The node with key %lf does not exist",*(double *)dkey);
			}
			else if (s == 3)
			{
				l=1;
				printf("\n\n The node with key  ");
				while (*(char *)(ckey->c+l) != '\0')
				{
					printf("%c", *(char *)(ckey->c+l-1));
					l=l+1;
				}
				printf("\n does not exist");
			}
		}
        else if ((rox!=*root) && (rox->l==NULL) && (rox->r==NULL))
        {
			delete_message(rox,s);
            if ((rox->p->l != NULL) && (compare(rox->p->l->k,rox->k,s) == 0))  // ((rox->p->l!=NULL) && (rox->p->l->k==rox->k))
            {
                delete_fixup(rox,&vox);
                rox->p->l=NULL;
                (*root)=vox;
                free(rox);
            }
            else if ((rox->p->r != NULL) && (compare(rox->p->r->k,rox->k,s) == 0))  // ((rox->p->r!=NULL) && (rox->p->r->k==rox->k))
            {
                delete_fixup(rox,&vox);
                rox->p->r=NULL;
                (*root)=vox;
                free(rox); 
            }
            printf(" has been deleted\n");
        }
        else if ((rox==*root) && (rox->l==NULL) && (rox->r==NULL))
        {
        	delete_message(rox,s);
            free(rox);
            *root=NULL;
            printf(" has been deleted\n");
        }
        else if ((rox==*root) && (rox->l==NULL) && (rox->r!=NULL))
        {
        	delete_message(rox,s);
            delete_fixup(rox,&vox);
            rox->r->p=rox->r;
            *root=rox->r;
            free(rox);
            printf(" has been deleted\n");
        }
        else if ((rox==*root) && (rox->l!=NULL) && (rox->r==NULL))
        {
        	delete_message(rox,s);
            delete_fixup(rox,&vox);
            rox->l->p=rox->l;
            *root=rox->l;
            free(rox);
            printf(" has been deleted\n");
        }
        else if ((rox!=*root) && (rox->l!=NULL) && (rox->r==NULL))
        {
        	delete_message(rox,s);
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
            printf(" has been deleted\n");
        }
        else if ((rox!=*root) && (rox->l==NULL) && (rox->r!=NULL))
        {
        	delete_message(rox,s);
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
            printf(" has been deleted\n");
        }
        else if ((rox==*root) ||(rox!=*root) && (rox->l!=NULL) && (rox->r!=NULL))
        {
        	delete_message(rox,s);
            axe=rox->l;
            while (axe!=NULL)
            {
                exchange_delete_node_a(axe,rox,&vox);
                axe=axe->r;
            }
            printf(" has been deleted\n");
        }
        
        if (s == 1)
		{
    		free(ikey);
	    }
	    else if (s == 2)
	    {
	    	free(dkey);
		}
		else if (s == 3)
		{
			free(ckey);
		}
    }
}

void delete_message(tp rox, int s)
{
	int j;
	
	if (s == 1)
    {
		printf("\n The node with the key  %d ",*(int *)(rox->k));
	}
	else if (s == 3)
	{
		j=1;
		printf("\n\n The node with the key  ");
		while (*(char *)(rox->k+j) != '\0')
		{
			printf("%c", *(char *)(rox->k+j-1));
			j=j+1;
		}
		printf(" ");
	}
}

void find_node(tp x,tp* rox,void *key,int s)
{
    if ((compare(x->k,key,s) != 0) && (x->l != NULL))  // ((x->k!=key) && (x->l!=NULL))
    {
        find_node(x->l,rox,key,s);
    }
    
    if (compare(x->k,key,s) == 0)  // (x->k==key)
    {
        *rox=x;
    }
    
    if ((compare(x->k,key,s) != 0) && (x->r != NULL)) // ((x->k!=key) && (x->r!=NULL))
    {
        find_node(x->r,rox,key,s);
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
