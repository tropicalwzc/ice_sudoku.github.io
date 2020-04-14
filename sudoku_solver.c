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

//清空x,y点行列宫范围内的候选数
void clear_point(int sudo[10][9][9], int trnum, int x, int y)
{
    for (int v = 0; v < 9; v++)
    {
        sudo[trnum][v][y] = 0;
        sudo[trnum][x][v] = 0;
        sudo[v + 1][x][y] = 0;
    }

    for (int r = 0; r < 9; r++)
        sudo[trnum][r / 3 + x - x % 3][r % 3 + y - y % 3] = 0;
}
//完全清空候选数数组
void clear_bits(int save[10][9][9])
{
    for (int i = 0; i < 9; i++)
        for (int j = 0; j < 9; j++)
        {
            for (int p = 1; p <= 9; p++)
                save[p][i][j] = 0;
        }

}
//判断两个数独否完全一致
int isthesame(int sudo[9][9], int sudoext[9][9])
{
    for (int i = 0; i < 9; i++)
        for (int k = 0; k < 9; k++)
        {
            if (sudo[i][k] != sudoext[i][k])
                return 0;
        }
    return 1;
}
//复制数独
void copysudo(int sudo[9][9], const int sudoext[9][9])
{
    int i, k;
    for (i = 0; i < 9; i++)
        for (k = 0; k < 9; k++)
        {
            sudo[i][k] = sudoext[i][k];
        }
    return;
}
//候选数模式复制数独
void bitcopysudo(int sudo[10][9][9], const int sudoext[10][9][9])
{
    int i, k, p;
    for (p = 0; p < 10; p++)
        for (i = 0; i < 9; i++)
            for (k = 0; k < 9; k++)
            {
                sudo[p][i][k] = sudoext[p][i][k];
            }
}
//判断是否允许填入(x,y)点的z值
int canputin(const int sudo[9][9], int x, int y, int z)
{
    if (sudo[x][y] != 0)
        return -1;
    int a, b;

    for (a = 0; a < 9; a++)
    {
        if (sudo[a][y] == z)
            return -1;
    }

    for (b = 0; b < 9; b++)
    {
        if (sudo[x][b] == z)
            return -1;
    }

    for (a = (x / 3) * 3; a < (x / 3) * 3 + 3; a++)
        for (b = (y / 3) * 3; b < (y / 3) * 3 + 3; b++)
        {
            if (sudo[a][b] == z) {
                return -1;
            }

        }

    return 1;

}
//求和
int sumlay(const int lay[9][9], int q, int p)
{
    int x, y;

    for (x = q * 3; x < q * 3 + 3; x++)
        for (y = p * 3; y < p * 3 + 3; y++)
        {
            if (!lay[x][y])
                return 0;
        }
    return 9;
}
//判断是否在(x,y)所在九宫格内存在z值
int isexist(const int sudo[9][9], int x, int y, int z)
{
    for (int a = (x / 3) * 3; a < (x / 3) * 3 + 3; a++) {
        for (int b = (y / 3) * 3; b < (y / 3) * 3 + 3; b++)
        {
            if (sudo[a][b] == z)
                return -1;
        }
    }
    return 1;
}
//构建候选数全图，无自动更新
int low_build_bit(int sudo[10][9][9])
{
    int i, k, f;
    for (f = 1; f < 10; f++)
        for (i = 0; i < 9; i++)
        {
            for (k = 0; k < 9; k++)
            {
                if (sudo[0][i][k] == 0)
                {
                    if (canputin(sudo[0], i, k, f) == 1)
                    {
                        sudo[f][i][k] = 1;
                    }
                }
            }
        }
    return 1;
}
//点排除模式刷新数独
int change_bit(int sudo[10][9][9])
{
    int con = 0, py = 0, l, v, i, k, al = 0;

    for (i = 0; i < 9; ++i) {
        for (k = 0; k < 9; ++k)
        {
            if (sudo[0][i][k] != 0)
                continue;

            for (l = 1; l <= 9; ++l)
            {
                if (sudo[l][i][k] == 1)
                {
                    if (con == 1)
                    {
                        con = 0;
                        break;
                    }
                    else {
                        con = 1;
                        py = l;
                    }
                }
            }
            if (con == 1)
            {
                sudo[0][i][k] = py;
                for (v = 0; v < 9; v++)
                {
                    sudo[py][v][k] = sudo[py][i][v] = sudo[py][v / 3 + i - i % 3][v % 3 + k - k % 3] = 0;
                }
                al = 1;
                con = 0;
            }
        }
    }
    return al;
}
//宫排除模式刷新数独
int square_bit(int sudo[10][9][9])
{

    int label = 0, p, a, b, i, k, block[10] = {};
    for (a = 0; a < 3; ++a) {//row
        for (b = 0; b < 3; ++b)//col
        {


            for (i = a * 3; i < a * 3 + 3; ++i)
            {
                for (k = b * 3; k < b * 3 + 3; ++k)
                {
                    if (sudo[0][i][k] != 0)
                        continue;
                    for (p = 1; p < 10; p++)
                        block[p] += sudo[p][i][k];
                }
            }
            for (p = 1; p < 10; ++p)
            {
                if (block[p] == 1)
                {
                    for (int r = 0; r < 9; r++)
                    {
                        i = r / 3 + a * 3;
                        k = r % 3 + b * 3;
                        if (sudo[p][i][k] == 1)
                        {
                            sudo[0][i][k] = p;

                            for (int u = 1; u < 10; u++)
                                sudo[u][i][k] = 0;

                            for (int v = 0; v < 9; v++)
                            {
                                sudo[p][v][k] = 0;
                                sudo[p][i][v] = 0;
                            }
                            label = 1;
                            break;
                        }
                    }
                }
                block[p] = 0;
            }
        }
    }
    return label;
}
//行排除刷新数独
int row_bit(int sudo[10][9][9])
{
    int changeor = 0, i, k, p, row[10] = {};

    for (i = 0; i < 9; ++i)
    {
        for (k = 0; k < 9; ++k)
        {
            if (sudo[0][i][k] != 0) {
                continue;
            }
            for (p = 1; p < 10; ++p)
                row[p] += sudo[p][i][k];
        }
        for (p = 1; p < 10; ++p)
        {
            if (row[p] == 1)
            {
                for (k = 0; k < 9; k++)
                {
                    if (sudo[p][i][k] == 1)
                    {
                        sudo[0][i][k] = p;


                        for (int u = 1; u < 10; u++)
                            sudo[u][i][k] = 0;

                        for (int v = 0; v < 9; v++)
                            sudo[p][v][k] = 0;

                        for (int r = 0; r < 9; r++)
                            sudo[p][r / 3 + i - i % 3][r % 3 + k - k % 3] = 0;

                        changeor = 1;
                        break;
                    }
                }
            }
            row[p] = 0;
        }
    }

    return changeor;
}
//列排除模式刷新数独
int col_bit(int sudo[10][9][9])
{
    int changeor = 0, col[11] = {}, colnum[11] = {};
    for (int k = 0; k < 9; ++k)
    {
        for (int i = 0; i < 9; ++i)
        {
            if (sudo[0][i][k] != 0) {
                continue;
            }
            for (int p = 1; p < 10; ++p)
            {
                if (sudo[p][i][k] == 1)
                {
                    col[p]++;
                    colnum[p] = i;
                }
            }
        }
        for (int p = 1; p < 10; ++p)
        {
            if (col[p] == 1)
            {
                sudo[0][colnum[p]][k] = p;
                for (int u = 0; u < 9; u++)
                {
                    sudo[p][colnum[p]][u] = sudo[p][u / 3 + colnum[p] - colnum[p] % 3][u % 3 + k - k % 3] = sudo[u + 1][colnum[p]][k] = 0;
                }
                changeor = 1;
            }
            col[p] = 0;
        }
    }
    return changeor;
}
//综合使用行列宫点排除进行快速刷新候选数图
int presolvesudo(int sudo[10][9][9])
{
    int lok = 0;
    while (square_bit(sudo) || row_bit(sudo) || col_bit(sudo))
    {
        change_bit(sudo);
        lok = 1;
    }
    return lok;


}
//构建基础候选数图并且加入自动快速更新
int build_bit(int sudo[10][9][9])
{
    int i, k, f;
    for (f = 1; f < 10; f++)
        for (i = 0; i < 9; i++)
        {
            for (k = 0; k < 9; k++)
            {
                if (sudo[0][i][k] == 0)
                {
                    if (canputin(sudo[0], i, k, f) == 1)
                    {
                        sudo[f][i][k] = 1;
                    }
                }
            }
        }
    presolvesudo(sudo);

    return 1;
}
//判断当前数独是否存在无解矛盾
int linecheck(int tempsudo[10][9][9])
{
    //-----------------------------------------------------------------------------
    // check logic error in col row block and single
    //-----------------------------------------------------------------------------
    for (int p = 1; p < 10; p++)
        for (int i = 0; i < 9; i++)
        {
            for (int k = 0; k < 9; k++)
            {
                if (tempsudo[0][i][k] == p)
                    break;
                if (tempsudo[p][i][k] == 1)
                    break;
                if (k == 8)
                    return 0;
            }
        }
    for (int p = 1; p < 10; p++)
        for (int i = 0; i < 9; i++)
        {
            for (int k = 0; k < 9; k++)
            {
                if (tempsudo[0][k][i] == p)
                    break;
                if (tempsudo[p][k][i] == 1)
                    break;
                if (k == 8)
                    return 0;
            }
        }
    for (int p = 1; p < 10; p++)
        for (int i = 0; i < 9; i++)
        {
            for (int k = 0; k < 9; k++)
            {
                if (tempsudo[0][i - i % 3 + k / 3][i % 3 * 3 + k % 3] == p)
                    break;
                if (tempsudo[p][i - i % 3 + k / 3][i % 3 * 3 + k % 3] == 1)
                    break;
                if (k == 8)
                    return 0;
            }
        }

    for (int i = 0; i < 9; i++)
    {
        for (int k = 0; k < 9; k++)
        {
            for (int p = 0; p < 10; p++)
            {
                if (tempsudo[p][i][k] != 0)
                    break;
                if (p == 9)
                    return 0;
            }
        }
    }

    return 1;
}
//数独是否存在空格?
int isvacant(const int sudo[9][9])
{
    for (int i = 0; i < 9; i++)
        for (int k = 0; k < 9; k++)
        {
            if (sudo[i][k] == 0)
                return 1;
        }
    return 0;
}
//数独是否求解完毕?
int isok(const int sudo[9][9])
{
    int i, k, mul, sum = 0;

    for (i = 0; i < 9; i++)
    {
        sum = 0; mul = 1;
        for (k = 0; k < 9; k++)
        {
            sum += sudo[i][k];
            mul *= sudo[i][k];
        }
        if (sum != 45 || mul != 362880)
            return -1;
    }

    for (k = 0; k < 9; k++)
    {
        sum = 0; mul = 1;
        for (i = 0; i < 9; i++)
        {
            sum += sudo[i][k];
            mul *= sudo[i][k];
        }
        if (sum != 45 || mul != 362880)
            return -1;
    }
    return 1;
}
//检测两个数独是否一样
int check(const int sudo[9][9], const int sudoext[9][9])
{
    for (int i = 0; i < 9; i++)
        for (int k = 0; k < 9; k++)
        {
            if (sudoext[i][k] != 0)
                if (sudo[i][k] != sudoext[i][k])
                    return -1;
        }
    return 1;
}
//随机快速求解数独
void solvesudo(int sudo[10][9][9], int sudoext[9][9])
{
    int rng, x, y, q, p, trnum;
    int lay[9][9] = {};
    int backer = 0;
    int dt = 0;

    int sudop[10][9][9] = {};
    copysudo(sudop[0], sudoext);
    //建立基础候选数图
    build_bit(sudop);

    if (isvacant(sudop[0]) == 0)
    {
        //90%以上的数独时最简单的，连一次刷新都挺不过就求解完毕了
        //可以直接返回
        copysudo(sudo[0], sudop[0]);
        return;
    }
    //记录已访问
    int havetry[10] = {};


    do {
        dt = 0;
        backer = 0;
        for (int i = 0; i < 10; i++)
            havetry[i] = 0;
        
        //候选数恢复现场
        bitcopysudo(sudo, sudop);

        for (dt = 1; dt < 10; dt++)// fill num 1-9
        {
            trnum = rand() % 9 + 1;
            while (havetry[trnum] == 1) {
                trnum = rand() % 9 + 1;
            }
            havetry[trnum] = 1;
            // dt++;

            if (dt >= 2)
                if (!linecheck(sudo))
                {
                    //已经出现错误，返回恢复现场重新尝试
                    backer = 2;
                    break;
                }
            if (dt >= 2)
                if (isvacant(sudo[0]) == 0)
                {
                    //似乎已经求解完成,检测一下
                    break;
                }
            for (int ii = 0; ii < 9; ii++)
                for (int kk = 0; kk < 9; kk++)
                    lay[ii][kk] = 0;

            for (int b = 0; b < 9; b++)
            {
                p = b / 3;
                q = b % 3;

                if (isexist(sudo[0], q * 3, p * 3, trnum) == -1) {
                    continue;
                }

                x = rand() % 3 + q * 3;
                y = rand() % 3 + p * 3;
                lay[x][y] = 1;


                rng = sudo[trnum][x][y];
                //   rng=canputin(sudo[0],x,y,trnum);
                while (rng != 1)
                {
                    x = rand() % 3 + q * 3;
                    y = rand() % 3 + p * 3;
                    if (lay[x][y] == 1)
                    {
                        continue;
                    }
                    lay[x][y] = 1;

                    if (sumlay(lay, q, p) == 9)
                    {
                        break;
                    }
                    rng = sudo[trnum][x][y];
                    //rng=canputin(sudo[0],x,y,trnum);

                }

                if (sudo[0][x][y] == 0) {
                    sudo[0][x][y] = trnum;
                    clear_point(sudo, trnum, x, y);
                    presolvesudo(sudo);
                }
                else {
                    //已经尝试过所有情况，仍然没有返回意味着已经在这个九宫格的trnum无法满足，返回重试
                    backer = 2;
                    break;
                }
            }
        }
    } while (backer == 2 || isok(sudo[0]) == -1 || check(sudo[0], sudoext) == -1);
    //只有经过验证和原有数字完全一样的已经完全符合数独规则的81个格全部填写完毕才算求解完毕
}
void print_a_sudoku(int sudoku[10][9][9])
{
    printf("  -----   -----   -----\n");
    for (int i = 0; i < 9; i++) {
        printf("| ");
        for (int j = 0; j < 9; j++)
        {
            printf("%d ", sudoku[0][i][j]);
            if (j % 3 == 2)
                printf("| ");
        }
        printf("\n");
        if (i % 3 == 2)
        {
            printf("  -----   -----   -----\n");
        }
    }
}
int dialog_sudoku(int sudoku[9][9])
{
    int hp[10] = {};
    for (int i = 0; i < 9; i++)
    {
        hp[sudoku[i][i]]++;
        if (hp[sudoku[i][i]] > 1)
            return 0;
    }
    int fp[10] = {};
    for (int i = 0; i < 9; i++)
    {
        int j = 8 - i;
        fp[sudoku[i][j]]++;
        if (fp[sudoku[i][j]] > 1)
            return 0;
    }
    return 1;
}
int main(int argc, const char* argv[]) {
    // insert code here...
    srand(time(0));
    char inter[100];
    scanf("%s", &inter);
    int sudoans[10][9][9];
    int sudoin[9][9] = {};
    for (int i = 0; i < 81; i++)
    {
        sudoin[i / 9][i % 9] = inter[i] - '0';
    }

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

/* 可以用以下这些超困难数独测试，可以肯定凭借人脑基本上都不可能做出来的

                         @"500000300020100070008000009040007000000821000000600010300000800060004020009000005",
                         @"800000009040001030007000600000023000050904020000105000006000700010300040900000008",
                         @"000070100000008050020900003530000000062000004094600000000001800300200009000050070",
                         @"000006080000100200009030005040070003000008010000200600071090000590000004804000000",
                         @"000056000050109000000020040090040070006000300800000002300000008002000600070500010",
                         @"500000004080006090001000200070308000000050000000790030002000100060900080400000005",
                         @"070200009003060000400008000020900010800004000006030000000000600090000051000700002",
                         @"100080000005900000070002000009500040800010000060007200000000710000004603030000402",
                         @"000900100000080007004002050200005040000100900000070008605000030300006000070000006",
                         @"000001080030500200000040006200300500000008010000060004050000700300970000062000000",
                         @"800000005040003020007000100000004000090702060000639000001000700030200040500000008",
                         @"900000001030004070006000200050302000000060000000078050002000600040700030100000009",
                         @"500000008030007040001000900020603000000725000000800060009000100070400030800000005",
                         @"400000009070008030006000100050702000000065000000003020001000600080300070900000004",
                         @"100006009007080030000200400000500070300001002000090600060003050004000000900020001",
                         @"800000001050009040003000600070056000000980000000704020006000300090400050100000008",
                         @"010000009005080700300700060004250000000000000000840200008007500600000030090000001",
                         @"300000005020007040001000900080036000000028000000704060009000100070400020500000003",
                         @"400000003080002060007000900010508000000701000000026050009000700020600080300000004",
                         @"600005020040700000009080000010000302000000087000200104070400003500006000008090000",
                         @"007002000500090400010600000400050003060100000002007000000000810900000306000080059",
                         @"000007090000800400003060001420010000031000002605000000060400800500020006000009070",
                         @"000600001000020400300009050090005030000040200000100006570008000002000000080000090",
                         @"006003000900080200070400000003006000040700000800020090500000008000000709000510020",
                         @"010300000000009000000710050004050900200000006070800030600000002080030070009000400",
                         @"000008070000300200005040009260094000059000006401000000000200300100060004000007080",
                         @"000800300000010005004002070200007040000300807000050001907000060600009000050000000",
                         @"800000007040001030009000600000532000050108020000400000006000900010300040700000008",
                         @"400000008050002090001000600070503000000060000000790030006000100020900050800000004",
                         @"300000009010006050002000400070060000000701000000845070004000200060500010900000003",
                         @"000000789000100036009000010200030000070004000008500100300020000005800090040007000",
                         @"100000000006700020080030500007060030000500008000004900300800600002090070040000001",
                         @"700000005040001030002000900060008000000946000000103080009000200010300040500000007",
                         @"001020000300004000050600070080900005002003000400010000070000038000800069000000200",
                         @"007580000000030000000076005400000020090000100003060008010600900006800003200000040",
                         @"097000000301005000045000800003008400000020060000100009700004300000900001000060020",
                         @"003700000050004000100020080900000012000000400080010090007300000200090006040005000",
                         @"000000100600000874000007026030400000005090000100008002009050000200001008040300000",
                         @"100000004020006090005000800030650000000372000000098070008000500060900020400000001",
                         @"005300000800000020070010500400005300010070006003200080060500009004000030000009700",
                         @"000002005006700400000009008070090000600400700010000080060300100300000002400005000",
                         @"020000600400080007009000010005006000300040900010200000000700004000001050800090300",
                         @"900000007030008040006000200010389000000010000000205010002000600080400030700000009",
                         @"002400006030010000500008000007000002010000030900600400000007001000090080400200500",
                         @"100300000020090400005007000800000100040000020007060003000400800000020090006005007",
                         @"002600000030080000500009100006000002080000030700001400000004005010020080000700900",
                         @"003500100040080000600009000800000002050700030001000400000006009000020080070100500",
                         @"300000906040200080000060000050800020009000307000007000010042000000000010508100000",
                         @"000090050010000030002300700004500070800000200000006400090010000080060000005400007",
                         @"100500000200000030004060100006007000008000009400080200000009007040010600000005003"
*/
