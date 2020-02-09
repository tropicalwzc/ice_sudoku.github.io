import numpy
import random
from random import randint
#  main.py
#  sudokucore
#
#  Created by 王子诚 on 2020//1//14.
#  Copyright © 2020 王子诚. All rights reserved.
#

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
da3 =[0]*3
da33 =[0]*3
remainder =[0]*10
divider =[0]*10
closebythree =[0]*10
closebythree_plus3=[0]*10
modeclose_bythree=[0]*10
backword =[0]*10

for i in range(0,3):
    da3[i]=i*3
    da33[i]=da3[i]+3
    
for p in range(0,10):
    backword[p]=9-p
    remainder[p]=p%3
    divider[p]=p//3
    closebythree[p]=p//3*3
    closebythree_plus3[p]=closebythree[p]+3
    modeclose_bythree[p]=p%3*3
    
def clear_point(sudo,trnum,x,y):

    for v in range(0,9):
        sudo[trnum][v][y]=0
        sudo[trnum][x][v]=0
        sudo[v+1][x][y]=0
    
    
    for r in range(0,9):
        sudo[trnum][r//3+x-x%3][r%3+y-y%3]=0;

def clear_bits(save):

    for i in range(0,9):
        for j in range(0,9):
            for p in range(0,10):
                save[p][i][j]=0;
        
    


def isthesame(sudo,sudoext):

    for i in range(0,9):
        for k in range(0,9):
            if(sudo[i][k]!=sudoext[i][k]):
                return 0;
        
    return 1;


def copysudo(sudo,sudoext):

    for i in range(0,9):
        for k in range(0,9):
            sudo[i][k]=sudoext[i][k];
        
    return ;

def bitcopysudo(sudo,sudoext):

    for p in range(0,10):
        for i in range(0,9):
            for k in range(0,9):
                sudo[p][i][k]=sudoext[p][i][k];
            

def canputin(sudo,x,y,z):

    if(sudo[x][y]!=0):
        return -1;

    for a in range(0,9):
    
        if(sudo[a][y]==z):
            return -1;
    
    
    for b in range(0,9):
    
        if(sudo[x][b]==z):
            return -1;
    
    
    for a in range(x//3*3,x//3*3+3):
        for b in range(y//3*3,y//3*3+3):
        
            if(sudo[a][b]==z):
                return -1;
            
            
        
    
    return 1;
    

def sumlay(lay,q,p):

    for x in range(q*3,q*3+3):
        for y in range(p*3,p*3+3):
        
            if(lay[x][y]==False):
                return 0;
        
    return 9;

def isexist(sudo,x, y, z):

    for a in range(x//3*3,x//3*3+3):
        for b in range(y//3*3,y//3*3+3):
        
            if(sudo[a][b]==z):
                return -1;
        
    
    return 1;



def change_bit(sudo):

    con=0
    py=0
    al=0
    
    for si in range(0,9):
        for sk in range(0,9):
        
            i=si;
            k=sk;
            
            if(sudo[0][i][k]!=0):
                continue;
            
            for l in range(1,10):
                if(sudo[l][i][k]==1):
                    if(con==1):
                        con=0;
                        break;
                    else:
                        con=1;
                        py=l;
                    
                
            
            if(con==1):
                sudo[0][i][k]=py;
                for v in range(0,9):
                    sudo[py][v][k]=0;
                    sudo[py][i][v]=0;
                    sudo[py][divider[v]+closebythree[i]][remainder[v]+closebythree[k]]=0;
                
                al=1;
                con=0;
            
        
    
    return al;


def square_bit (sudo):

    label=0
    block=[0]*10;

    for a in range(0,3):
        for b in range(0,3):
        
            for i in range(da3[a],da33[a]):
                for k in range(da3[b],da33[b]):
                
                    if(sudo[0][i][k]!=0):
                        continue;
                    for p in range(1,10):
                        block[p]+=sudo[p][i][k];
                
            
            for p in range(1,10):
                if(block[p]==1):
                    for r in range(0,9):
                        i=divider[r]+da3[a]
                        k=remainder[r]+da3[b]
                        if(sudo[p][i][k]==1):
                        
                            sudo[0][i][k]=p;
                            
                            for u in range(1,10):
                                sudo[u][i][k]=0;
                            
                            for v in range(0,9):
                                sudo[p][v][k]=0;
                                sudo[p][i][v]=0;
                            
                            label=1;
                block[p]=0;
    return label;


def row_bit (sudo):

    changeor=0
    row=[0]*10
    for si in range(0,9):
    
        i=si;
        for sk in range(0,9):
        
            if(sudo[0][i][sk]!=0):
                continue;
            
            for p in range(1,10):
                row[p]+=sudo[p][i][sk];
        
        for p in range(1,10):
        
            if(row[p]==1):
            
                for k in range(0,9):
                
                    if(sudo[p][i][k]==1):
                    
                        sudo[0][i][k]=p;
                        for r in range(0,9):
                            sudo[r+1][i][k]=0;
                            sudo[p][r][k]=0;
                            sudo[p][divider[r]+closebythree[i]][remainder[r]+closebythree[k]]=0;
                        changeor=1;

            row[p]=0;

    return changeor;

def col_bit(sudo):

    changeor=0
    col=[0]*10
    colnum=[0]*10
    for sk in range(0,9):
    
        k=sk;
        for si in range(0,9):
        
            if(sudo[0][si][k]!=0):
                continue;
            
            for p in range(1,10):
            
                if(sudo[p][si][k]==1):
                
                    col[p]+=1;
                    colnum[p]=si;
                
            
        
        for p in range(1,10):
        
            if(col[p]==1):
            
                sudo[0][colnum[p]][k]=p;
                
                for u in range(0,9):
                    sudo[p][colnum[p]][u]=0;
                    sudo[p][divider[u]+closebythree[colnum[p]]][remainder[u]+closebythree[k]]=0;
                    sudo[u+1][colnum[p]][k]=0;
                
                changeor=1;
            
            col[p]=0;
        
    
    
    return changeor;


def presolvesudo(sudo):

    lok=change_bit(sudo)
    
    while(square_bit(sudo)==1 or col_bit(sudo)==1 or row_bit(sudo)==1):
    
        change_bit(sudo)
        lok=1
    
    return lok

    
def build_bit(sudo):


    for f in range(0,10):
        for i in range(0,9):
            for k in range(0,9):
                if(sudo[0][i][k]==0):
                
                    if(canputin(sudo[0],i,k,f)==1):
                        sudo[f][i][k]=1;
                
    presolvesudo(sudo);
    
    return 1;

def low_build_bit(sudo):

    for f in range(0,10):
        for i in range(0,9):

            for k in range(0,9):
            
                if(sudo[0][i][k]==0):
                
                    if(canputin(sudo[0],i,k,f)==1):
                        sudo[f][i][k]=1;

    return 1;


def linecheck(tempsudo):

    for p in range(1,10):
        for i in range(0,9):
    
            for k in range(0,9):
            
                if(tempsudo[0][i][k]==p):
                    break;
                if(tempsudo[p][i][k]==1):
                    break;
                if(k==8):
                    return 0;
            
        
    for p in range(1,10):
        for i in range(0,9):
            for k in range(0,9):
            
                if(tempsudo[0][k][i]==p):
                    break;
                if(tempsudo[p][k][i]==1):
                    break;
                if(k==8):
                    return 0;
            
        
    for p in range(1,10):
        for i in range(0,9):
            for k in range(0,9):
            
                if(tempsudo[0][i-i%3+k//3][i%3*3+k%3]==p):
                    break;
                if(tempsudo[p][i-i%3+k//3][i%3*3+k%3]==1):
                    break;
                if(k==8):
                    return 0;
            
        
    
    for i in range(0,9):
    
        for k in range(0,9):
        
            for p in range(0,10):
            
                if(tempsudo[p][i][k]!=0):
                    break;
                if(p==9):
                    return 0;
            
        
    
    
    return 1;

def isvacant(sudo):

    for i in range(0,9):
        for k in range(0,9):
        
            if(sudo[i][k]==0):
                return 1;
        
    return 0;

def isok(sudo):

    mul=0;
    sum=0;
    
    for i in range(0,9):
    
        sum=0;mul=1;
        for k in range(0,9):
        
            sum+=sudo[i][k];
            mul*=sudo[i][k];
        
        if(sum!=45 or mul!=362880):
            return -1;
    
    
    for k in range(0,9):
    
        sum=0;mul=1;
        for i in range(0,9):
        
            sum+=sudo[i][k];
            mul*=sudo[i][k];
        
        if(sum!=45 or mul!=362880):
            return -1;
    
    return 1;

def check(sudo,sudoext):

    for i in range(0,9):
        for k in range(0,9):
        
            if(sudoext[i][k]!=0):
                if(sudo[i][k]!=sudoext[i][k]):
                    return -1;
        
    return 1;

def solvesudo(sudo,sudoext):


    lay = [[0]*9 for _ in range(0,9)];
    backer=0;
    dt=0;
    
    sudop= [[[0]*9 for _ in range(0,9)] for _ in range(0,10)];
    copysudo(sudop[0],sudoext);
    build_bit(sudop);
    
    if(isvacant(sudop[0])==0):
    
        copysudo(sudo[0],sudop[0]);
        return;
    
    
    havetry=[0]*10;
    first_start=True
    #print(sudop[0])
    while (first_start==True or (backer==2 or isok(sudo[0])==-1 or check(sudo[0],sudoext)==-1)):
        first_start=False
        dt=0;
        backer=0;
        for i in range(0,10):
            havetry[i]=0;
        
        bitcopysudo(sudo,sudop);
        
        for dt in range(1,9):# fill num 1-9 
            

            trnum=randint(1,9);
            while (havetry[trnum]==1): 
                trnum=randint(1,9);
            
            havetry[trnum]=1;
            # dt++;
            
            if(dt>=2):
                if(linecheck(sudo)==0):
                    backer=2;
                    break;
                
            if(dt>=2):
                if(isvacant(sudo[0])==0):
                    break;
                
            for ii in range(0,9):
                for kk in range(0,9):
                    lay[ii][kk]=0;
            
            for b in range(0,9):
            
                p=b//3;
                q=b%3;
                
                if(isexist(sudo[0],q*3,p*3,trnum)==-1):
                    continue ;
                
                
                x=randint(0,2)+q*3;
                y=randint(0,2)+p*3;
                lay[x][y]=1;
                
                
                rng=sudo[trnum][x][y];
                #   rng=canputin(sudo[0],x,y,trnum);
                while(rng!=1):
                
                    x=randint(0,2)+q*3;
                    y=randint(0,2)+p*3;
                    if(lay[x][y]==1):
                    
                        continue;
                    
                    lay[x][y]=1;
                    
                    if(sumlay(lay,q,p)==9):
                    
                        break;
                    
                    rng=sudo[trnum][x][y];
                    #rng=canputin(sudo[0],x,y,trnum);
                    
                
                
                if(sudo[0][x][y]==0):
                    sudo[0][x][y]=trnum;
                    clear_point(sudo,trnum,x,y);
                    presolvesudo(sudo);
                    #presolvesudo(sudo);
                else:
                    backer=2;
                    break;
"""
inputer = input("缓冲")
inputer = input("缓冲")
inputer = input("input a 81 number sudoku:")
sudoans = [[[0]*9 for _ in range(0,9)] for _ in range(0,10)];
sudoin = [[0]*9 for _ in range(0,9)];

for i in range(0,9):
    for j in range(0,9):
        sudoin[i][j]=ord(inputer[i*9+j])-ord('0')

#print(sudoin)

solvesudo(sudoans,sudoin)
for i in range(0,9):
    for j in range(0,9):
        print(sudoans[0][i][j],end='')

    print("")
"""




def sudoku_solver(puzzle):
    inputer = ''
    for i in range(0,9):
        for j in puzzle[i]:
            inputer += str(j)
    sudoans = [[[0]*9 for _ in range(0,9)] for _ in range(0,10)];
    sudoin = [[0]*9 for _ in range(0,9)];

    for i in range(0,9):
        for j in range(0,9):
            sudoin[i][j]=ord(inputer[i*9+j])-ord('0')

    solvesudo(sudoans,sudoin)
    solution = []
    for i in range(0,9):
        solution.append(sudoans[0][i])
    return solution
