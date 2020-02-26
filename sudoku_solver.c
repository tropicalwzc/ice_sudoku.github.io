//
//  main.c
//  sudokucore
//
//  Created by 王子诚 on 2020/1/14.
//  Copyright © 2020 王子诚. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void clear_point(int sudo[10][9][9],int trnum,int x,int y)
{
    for(int v=0;v<9;v++)
    {
        sudo[trnum][v][y]=0;
        sudo[trnum][x][v]=0;
        sudo[v+1][x][y]=0;
    }
    
    for(int r=0;r<9;r++)
        sudo[trnum][r/3+x-x%3][r%3+y-y%3]=0;
}
void clear_bits(int save[10][9][9])
{
    for(int i=0;i<9;i++)
        for(int j=0;j<9;j++)
        {
            for(int p=1;p<=9;p++)
                save[p][i][j]=0;
        }
    
}

int isthesame(int sudo[9][9],int sudoext[9][9])
{
    for(int i=0;i<9;i++)
        for(int k=0;k<9;k++)
        {
            if(sudo[i][k]!=sudoext[i][k])
                return 0;
        }
    return 1;
}

void copysudo(int sudo[9][9],const int sudoext[9][9])
{
    int i,k;
    for(i=0;i<9;i++)
        for(k=0;k<9;k++)
        {
            sudo[i][k]=sudoext[i][k];
        }
    return ;
}
void bitcopysudo(int sudo[10][9][9],const int sudoext[10][9][9])
{
    int i,k,p;
    for(p=0;p<10;p++)
        for(i=0;i<9;i++)
            for(k=0;k<9;k++)
            {
                sudo[p][i][k]=sudoext[p][i][k];
            }
}
int canputin(const int sudo[9][9],int x,int y,int z)
{
    if(sudo[x][y]!=0)
        return -1;
    int a,b;
    
    for(a=0;a<9;a++)
    {
        if(sudo[a][y]==z)
            return -1;
    }
    
    for(b=0;b<9;b++)
    {
        if(sudo[x][b]==z)
            return -1;
    }
    
    for(a=(x/3)*3;a<(x/3)*3+3;a++)
        for(b=(y/3)*3;b<(y/3)*3+3;b++)
        {
            if(sudo[a][b]==z){
                return -1;
            }
            
        }
    
    return 1;
    
}
int sumlay(const int lay[9][9],int q,int p)
{
    int x,y;
    
    for(x=q*3;x<q*3+3;x++)
        for(y=p*3;y<p*3+3;y++)
        {
            if(!lay[x][y])
                return 0;
        }
    return 9;
}
int isexist(const int sudo[9][9],int x,int y,int z)
{
    for(int a=(x/3)*3;a<(x/3)*3+3;a++){
        for(int b=(y/3)*3;b<(y/3)*3+3;b++)
        {
            if(sudo[a][b]==z)
                return -1;
        }
    }
    return 1;
}
int build_bit(int sudo[10][9][9])
{
    int i,k,f;
    for(f=1;f<10;f++)
        for(i=0;i<9;i++)
        {
            for(k=0;k<9;k++)
            {
                if(sudo[0][i][k]==0)
                {
                    if(canputin(sudo[0],i,k,f)==1)
                    {
                        sudo[f][i][k]=1;
                    }
                }
            }
        }
    presolvesudo(sudo);
    
    return 1;
}
int low_build_bit(int sudo[10][9][9])
{
    int i,k,f;
    for(f=1;f<10;f++)
        for(i=0;i<9;i++)
        {
            for(k=0;k<9;k++)
            {
                if(sudo[0][i][k]==0)
                {
                    if(canputin(sudo[0],i,k,f)==1)
                    {
                        sudo[f][i][k]=1;
                    }
                }
            }
        }
    return 1;
}
int change_bit(int sudo[10][9][9])
{
    int con=0,py=0,l,v,i,k,al=0;
    
    for(i=0;i<9;++i){
        for(k=0;k<9;++k)
        {
            if(sudo[0][i][k]!=0)
                continue;
            
            for(l=1;l<=9;++l)
            {
                if(sudo[l][i][k]==1)
                {
                    if(con==1)
                    {
                        con=0;
                        break;
                    }
                    else{
                        con=1;
                        py=l;
                    }
                }
            }
            if(con==1)
            {
                sudo[0][i][k]=py;
                for(v=0;v<9;v++)
                {
                    sudo[py][v][k]=sudo[py][i][v]=sudo[py][v/3+i-i%3][v%3+k-k%3]=0;
                }
                al=1;
                con=0;
            }
        }
    }
    return al;
}
int square_bit(int sudo[10][9][9])
{
    
    int label=0,p,a,b,i,k,block[10]={};
    for(a=0;a<3;++a){//row
        for(b=0;b<3;++b)//col
        {
            
            
            for(i=a*3;i<a*3+3;++i)
            {
                for(k=b*3;k<b*3+3;++k)
                {
                    if(sudo[0][i][k]!=0)
                        continue;
                    for(p=1;p<10;p++)
                        block[p]+=sudo[p][i][k];
                }
            }
            for(p=1;p<10;++p)
            {
                if(block[p]==1)
                {
                    for(int r=0;r<9;r++)
                    {
                        i=r/3+a*3;
                        k=r%3+b*3;
                        if(sudo[p][i][k]==1)
                        {
                            sudo[0][i][k]=p;
                            
                            for(int u=1;u<10;u++)
                                sudo[u][i][k]=0;
                            
                            for(int v=0;v<9;v++)
                            {
                                sudo[p][v][k]=0;
                                sudo[p][i][v]=0;
                            }
                            label=1;
                            break;
                        }
                    }
                }
                block[p]=0;
            }
        }
    }
    return label;
}

int row_bit(int sudo[10][9][9])
{
    int changeor=0,i,k,p,row[10]={};
    
    for(i=0;i<9;++i)
    {
        for(k=0;k<9;++k)
        {
            if(sudo[0][i][k]!=0){
                continue;
            }
            for(p=1;p<10;++p)
                row[p]+=sudo[p][i][k];
        }
        for(p=1;p<10;++p)
        {
            if(row[p]==1)
            {
                for(k=0;k<9;k++)
                {
                    if(sudo[p][i][k]==1)
                    {
                        sudo[0][i][k]=p;
                        
                        
                        for(int u=1;u<10;u++)
                            sudo[u][i][k]=0;
                        
                        for(int v=0;v<9;v++)
                            sudo[p][v][k]=0;
                        
                        for(int r=0;r<9;r++)
                            sudo[p][r/3+i-i%3][r%3+k-k%3]=0;
                        
                        changeor=1;
                        break;
                    }
                }
            }
            row[p]=0;
        }
    }
    
    return changeor;
}
int col_bit(int sudo[10][9][9])
{
    int changeor=0,col[11]={},colnum[11]={};
    for(int k=0;k<9;++k)
    {
        for(int i=0;i<9;++i)
        {
            if(sudo[0][i][k]!=0){
                continue;
            }
            for(int p=1;p<10;++p)
            {
                if(sudo[p][i][k]==1)
                {
                    col[p]++;
                    colnum[p]=i;
                }
            }
        }
        for(int p=1;p<10;++p)
        {
            if(col[p]==1)
            {
                sudo[0][colnum[p]][k]=p;
                for(int u=0;u<9;u++)
                {
                    sudo[p][colnum[p]][u]=sudo[p][u/3+colnum[p]-colnum[p]%3][u%3+k-k%3]=sudo[u+1][colnum[p]][k]=0;
                }
                changeor=1;
            }
            col[p]=0;
        }
    }
    return changeor;
}
int presolvesudo(int sudo[10][9][9])
{
    int lok=0;
    while(square_bit(sudo)||row_bit(sudo)||col_bit(sudo))
    {
        change_bit(sudo);
        lok=1;
    }
    return lok;
    
    
}

int linecheck(int tempsudo[10][9][9])
{
    //-----------------------------------------------------------------------------
    // check logic error in col row block and single
    //-----------------------------------------------------------------------------
    for(int p=1;p<10;p++)
        for(int i=0;i<9;i++)
        {
            for(int k=0;k<9;k++)
            {
                if(tempsudo[0][i][k]==p)
                    break;
                if(tempsudo[p][i][k]==1)
                    break;
                if(k==8)
                    return 0;
            }
        }
    for(int p=1;p<10;p++)
        for(int i=0;i<9;i++)
        {
            for(int k=0;k<9;k++)
            {
                if(tempsudo[0][k][i]==p)
                    break;
                if(tempsudo[p][k][i]==1)
                    break;
                if(k==8)
                    return 0;
            }
        }
    for(int p=1;p<10;p++)
        for(int i=0;i<9;i++)
        {
            for(int k=0;k<9;k++)
            {
                if(tempsudo[0][i-i%3+k/3][i%3*3+k%3]==p)
                    break;
                if(tempsudo[p][i-i%3+k/3][i%3*3+k%3]==1)
                    break;
                if(k==8)
                    return 0;
            }
        }
    
    for(int i=0;i<9;i++)
    {
        for(int k=0;k<9;k++)
        {
            for(int p=0;p<10;p++)
            {
                if(tempsudo[p][i][k]!=0)
                    break;
                if(p==9)
                    return 0;
            }
        }
    }
    
    return 1;
}
int isvacant(const int sudo[9][9])
{
    for(int i=0;i<9;i++)
        for(int k=0;k<9;k++)
        {
            if(sudo[i][k]==0)
                return 1;
        }
    return 0;
}
int isok(const int sudo[9][9])
{
    int i,k,mul,sum=0;
    
    for(i=0;i<9;i++)
    {
        sum=0;mul=1;
        for(k=0;k<9;k++)
        {
            sum+=sudo[i][k];
            mul*=sudo[i][k];
        }
        if(sum!=45||mul!=362880)
            return -1;
    }
    
    for(k=0;k<9;k++)
    {
        sum=0;mul=1;
        for(i=0;i<9;i++)
        {
            sum+=sudo[i][k];
            mul*=sudo[i][k];
        }
        if(sum!=45||mul!=362880)
            return -1;
    }
    return 1;
}
int check(const int sudo[9][9],const int sudoext[9][9])
{
    for(int i=0;i<9;i++)
        for(int k=0;k<9;k++)
        {
            if(sudoext[i][k]!=0)
                if(sudo[i][k]!=sudoext[i][k])
                    return -1;
        }
    return 1;
}
void solvesudo(int sudo[10][9][9],int sudoext[9][9])
{
    int rng,x,y,q,p,trnum;
    int lay[9][9]={};
    int backer=0;
    int dt=0;
    
    int sudop[10][9][9]={};
    copysudo(sudop[0],sudoext);
    build_bit(sudop);
    
    if(isvacant(sudop[0])==0)
    {
        copysudo(sudo[0],sudop[0]);
        return;
    }
    
    int havetry[10]={};
    
    
    do{
        dt=0;
        backer=0;
        for(int i=0;i<10;i++)
            havetry[i]=0;
        
        bitcopysudo(sudo,sudop);
        
        for(dt=1;dt<10;dt++)// fill num 1-9
        {
            trnum=rand()%9+1;
            while (havetry[trnum]==1) {
                trnum=rand()%9+1;
            }
            havetry[trnum]=1;
            // dt++;
            
            if(dt>=2)
                if(!linecheck(sudo))
                {
                    backer=2;
                    break;
                }
            if(dt>=2)
                if(isvacant(sudo[0])==0)
                {
                    break;
                }
            for(int ii=0;ii<9;ii++)
                for(int kk=0;kk<9;kk++)
                    lay[ii][kk]=0;
            
            for(int b=0;b<9;b++)
            {
                p=b/3;
                q=b%3;
                
                if(isexist(sudo[0],q*3,p*3,trnum)==-1){
                    continue ;
                }
                
                x=rand()%3+q*3;
                y=rand()%3+p*3;
                lay[x][y]=1;
                
                
                rng=sudo[trnum][x][y];
                //   rng=canputin(sudo[0],x,y,trnum);
                while(rng!=1)
                {
                    x=rand()%3+q*3;
                    y=rand()%3+p*3;
                    if(lay[x][y]==1)
                    {
                        continue;
                    }
                    lay[x][y]=1;
                    
                    if(sumlay(lay,q,p)==9)
                    {
                        break;
                    }
                    rng=sudo[trnum][x][y];
                    //rng=canputin(sudo[0],x,y,trnum);
                    
                }
                
                if(sudo[0][x][y]==0){
                    sudo[0][x][y]=trnum;
                    clear_point(sudo,trnum,x,y);
                    presolvesudo(sudo);
                }
                else{
                    backer=2;
                    break;
                }
            }
        }
    }while(backer==2||isok(sudo[0])==-1||check(sudo[0],sudoext)==-1);
    
}
void print_a_sudoku(int sudoku[10][9][9])
{
    printf("  -----   -----   -----\n");
    for(int i=0;i<9;i++){
        printf("| ");
        for(int j=0;j<9;j++)
        {
            printf("%d ",sudoku[0][i][j]);
            if(j%3==2)
                printf("| ");
        }
        printf("\n");
        if(i%3==2)
        {
            printf("  -----   -----   -----\n");
        }
    }
}
int dialog_sudoku(int sudoku[9][9])
{
    int hp[10]={};
    for(int i=0;i<9;i++)
    {
        hp[sudoku[i][i]]++;
        if(hp[sudoku[i][i]]>1)
            return 0;
    }
    int fp[10]={};
    for(int i=0;i<9;i++)
    {
        int j=8-i;
        fp[sudoku[i][j]]++;
        if(fp[sudoku[i][j]]>1)
            return 0;
    }
    return 1;
}
int main(int argc, const char * argv[]) {
    // insert code here...
    srand(time(0));
    char inter[100];
    scanf("%s",&inter);
    int sudoans[10][9][9];
    int sudoin[9][9]={};
    for(int i=0;i<81;i++)
    {
        sudoin[i/9][i%9]=inter[i]-'0';
    }
    
    //000503000003700000670000043100057004000208000300416009726009415000105000000604000
    solvesudo(sudoans, sudoin);
    /* // 如果需要解对角线数独
    while (dialog_sudoku(sudoans[0])==0) {
        solvesudo(sudoans, sudoin);
        print_a_sudoku(sudoans);
    }
     */
    print_a_sudoku(sudoans);
    
    return 0;
}
