# BUPT-ASM

在8086/8088诞生40周年之际学的dos汇编，我们应该也是信通院最后一届学门课的人了，在GitHub备份一下我的汇编代码和实验报告。

## B

```text
实验二   分支,循环程序设计

一.实验目的:
    1.开始独立进行汇编语言程序设计;
    2.掌握基本分支,循环程序设计;
    3.掌握最简单的 DOS 功能调用.

二.实验内容:
    1.安排一个数据区（数据段）,内存有若干个正数,负数和零.每类数的个数都不超过 9.
    2.编写一个程序统计数据区中正数,负数和零的个数.
    3.将统计结果在屏幕上显示.

三.预习题:
    1.十进制数 0 -- 9 所对应的 ASCII 码是什么? 如何将十进制数 0 -- 9 在
 屏幕上显示出来?
    2.如何检验一个数为正,为负或为零? 你能举出多少种不同的方法?

四.选作题:
    统计出正奇数,正偶数,负奇数,负偶数以及零的个数.
```

## C

```text
实验三   代码转换程序设计

一.实验目的:
     1.掌握几种最基本的代码转换方法;
     2.运用子程序进行程序设计.

二.实验内容:
     1.从键盘上输入若干两位十进制数,寻找其中的最小值,然后在屏幕上显示出来.
     2.两个十进制数之间的分隔符,输入结束标志自定,但要在报告中说明.
     3.对输入要有检错措施,以防止非法字符输入,并有适当的提示.
     4.将整个程序分解为若干模块,分别用子程序实现.在报告中要给出模块层次图.

三.预习题:
     1.如何将输入的两个字符(0 -- 9)变为十进制或二进制数?
     2.如何将选出的最小值(二进制或十进制)变为 ASCII 码再进行显示?
     3.你觉得采用二进制运算还是十进制运算更适合于这个实验?

```

## D

```text
实验四   子程序设计

一.实验目的:
     1.进一步掌握子程序设计方法;
     2.进一步掌握基本的 DOS 功能调用.

二.实验内容:
     1.从键盘上输入某班学生的某科目成绩.输入按学生的学号由小到大的顺序输入.
     2.统计检查每个学生的名次.
     3.将统计结果在屏幕上显示.
     4.为便于观察,输入学生数目不宜太多,以不超过一屏为宜.输出应便于阅读.尽可
  能考虑美观.
     5.输入要有检错手段.

三.预习题:
     1.如何确定一个学生在这门科目中的名次?
     2.你觉得输入结束后,采用什么方法进行比较以得到学生的名次最为简单?
     3.准备好模块层次图.
     4.给出输出显示的形式.

```

## E(选做)

```text
实验五   中断程序设计

一.实验目的:
     1.初步掌握中断程序的设计方法:
     2.初步掌握修改 DOS 系统中断,以适应实际使用的方法.

二.实验内容:
     1.编写一个 32 位二进制数除以 16 位二进制数的除法程序.观察当除数为 0,或
  超过相应寄存器范围时,程序执行的结果.
     2.修改零号中断服务程序,使它具有以下功能:
      (1)判断除数是否为 0,当除数为 0 时,显示相应的结果;
      (2)当除数不为 0 时,采用适当的方法完成商超过 16 位的二进制数的除法运算.
     3.注意必须保护原有中断服务程序的入口地址,并在程序完毕前加以恢复.

三.预习题:
     1.如何保护原有中断向量表中的中断服务程序的入口地址?
     2.如何将你的中断服务程序入口地址置入中断向量表?

四.选作题:
     1.用二进制将结果在屏幕上显示.
     2.从键盘输入二进制数.

```