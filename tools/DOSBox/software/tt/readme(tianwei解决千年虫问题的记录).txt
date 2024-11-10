;第二次更新说明:
;由于TiANWEi的疏忽,没有放入正确的tt.his
;造成打字的某些地方出问题,现改正!

;note: i'd made a mistake in my old package(wrong tt.his packed)
;now i fixed it ,please download it from http://winice.yeah.net/


                      Type tutor IV

* zip package contains tt.exe, tt.hlp ,tt.his ,readme.txt, (,tty2k.exe)
* This package was from http://winice.yeah.net/
* tty2k.exe has y2k bug!
* tt.exe has been fixed by TiANWEi[Huainan,Anhui,China]
* Any question pls to spring_w@263.net

* FOLLOWING ARE CHINESE DETAILS AND DEBUG INFORMATION!




*******************************************************
* 本包包括readme.txt&tt.exe&tt.hlp&tt.his&(tty2k.exe) *
* 本软件包来自http://winice.yeah.net/                 *
* 转发请勿删除此说明!                                 *
* TT IV版本身软件包括tt.exe tt.hlp tt.his三个文件     *
* 此包中tt.exe为已经修改过的可执行文件                *
* 而tty2k.exe为老的有错误(2000年时间问题)的可执行文件 *
* 对编程有兴趣的朋友可参考下面的文章                  *
* 任何问题请:spring_w@263.net或到上述网址.            *
* 让我们的手指来跳舞!                                 *
*******************************************************


               TT Y2K Bug Fix


1.本篇讨论的是广泛流行的Typing Tutor IV.
2.本篇的读者需一定的汇编语言知识.
3.需要Numega的调试工具SoftICE
4.需要16进制的编辑工具(UltraEdit或HexEdit或WinHex等)

    TT可以说是初学电脑的人最常用的软件了,虽然它是80
年代编写的,但至今在中国仍然有广大的用户群,谁也不能否
认这个100多K的软件编得确实不错.在1999年岁末,全世界抓
虫,笔者所在的单位也呈繁荣景象,但谁也没有注意这个小东
西.而就在昨天(1/21),单位的MM在将近20天的忙碌工作后准
备放松一下,练练打字,一启动软件她就笑了:"日期错了!千
年虫!" 我向她保证马上DEBUG;)

    经过测试,错误表现在两个地方:

    1.选择姓名登陆的地方日期错误,
      应该为:01-21-00 (意思是2000年1月21日)
      显示为:01-21-10 而且后面的半句话:"Use up and 
      down arrow keys...."显示不出来
    2.更为严重的是:在进行Practice Test后应出现一个
      小统计表格,而此时异常退出程序,用MEM.EXE观察
      系统锁死.
      
而时间改成1999年就没有上面的情况.典型的Y2K错误.
时间匆忙,MM正等着呢!马上准备好工具:

    在SoftICE中用bpint 21 if (ah==2A)来下断点,TT在
进行到选择登陆的画面的时候被中断,因为它此时用INT 21的
2A号功能来取系统时间:
09F4:E5A6  B42A                MOV       AH,2A
09F4:E5A8  CD21                INT       21 ; 取时间
09F4:E5AA  8B5E04              MOV       BX,[BP+04]
09F4:E5AD  81E96C07            SUB       CX,076C ;年份
09F4:E5B1  894F0A              MOV       [BX+0A],CX
我们可以看到,它将时间减去76C(1900),然后存入[BX+0A]单元,
由于2000年为7D0,那么减去76C等于64(100),我们可以用SICE
在这个内存单元上下断来看TT对其的动作.由于篇幅关系,这里
不列出反汇编的代码了,只说明它的过程:TT的编写年代为80年
代,照顾到老DOS,所以它用了很多现在看来很多余的代码来计算
诸如星期几的问题,我们可以略过这些而直接找要害.我们可以
在09F4:BC82看到一个子例程(很长),是一个标准的将16进制数
转化为10进制数的过程,TT中很多地方调用了它,包括对时间的
显示,对练习进度的显示等等.在对日期显示时,先转化月,加一
个横杠"-",再转化日,再加一个"-",最后转化年,即如MM-DD-YY
形式.问题是转化后的目的空间是一个固定的已经分配的字符串
中间的部分,包括横杠在内只有8个字符位,而整个字符串是这样的:
"Is today's date XX-XX-XX?  Use up and down arrow ..."
当年份为0-99时没有问题,标准的转化程序工作得很好,只转化
两位数,但到了2000年时,传入此转化例程的参数为64(100),是
个3位数的十进制,转化程序仍旧"很严格地"执行操作,日期就
变成了XX-XX-100,而且吃掉了最后的问号,这都不要紧,问号在
后面还被补上了,关键是破坏了其中的一个计数值,将整个字符
串破开了......明白了吧! 由此可以想象Practice Test后的
统计表格,当中也是有日期的,而且那次情况更遭,系统异常!

   问题都清楚了,怎么解决呢?发现BUG,分析出BUG是一方面,
解决它又是另一个方面.我们想到:2000年实际上传的参数应该
是00,而不是64(100),程序是在哪里将64传出的呢? TT在获取
DOS年份后立刻减去1900,变为100,就象开头说的那样;但其后
它又恢复年份到7D0,直到转化显示日期又变成64作为参数:
09F4:C11B  8B46FA       MOV       AX,[BP-06] ;放7D0
09F4:C11E  0594F8       ADD       AX,F894    ;加F894
09F4:C121  99           CWD
注意:7D0加F894等于64! 问题就在这里! TT竟用这么简单的方
法来转换!
   怎样补丁呢?由于没有代码空间,我在TT的出错信息处:
"The files TT.EXE, TT.HLP, and TT.HIS must all be 
present on the same drive or directory from which 
you called Typing Tutor IV "
的"present"的后一单词处截断作为补丁空间.

1)在09F4:C11E处将ADD AX,F894改为:
09F4:C11E  E91A38  JMP F93B ;跳去补丁

2)在刚才的"present "后的"on the..."处打补丁:
09F4:F93B  2DD007       SUB       AX,07D0
09F4:F93E  7303         JAE       F943
09F4:F940  056400       ADD       AX,0064
09F4:F943  E9DBC7       JMP       C121 ;跳回去CWD处
再将"present"后的空格改为00
我的这个转化也够简单的,如果朋友们有兴趣,可以打更大的
补丁.

最后总结一下:用16进制编辑器在tt.exe(此次的tt.exe的字节
长度为100,592)中:

找: 8B 46 FA 05 94 F8 99
改: .. .. .. E9 1A 38 ..

找: 74 20 6F 6E 20 74 68 65
改: .. 00 2D D0 07 73 03 05 64 00 E9 DB C7

(注:标记为".."处表示不改.修改前先备份!)

这样,修改完毕! TT运行正常! MM们虽然认为我英文打字不
错,但都一直笑话我不会用五笔字形,尤其是那个打字室的
漂亮MM,还好,我总算挽回了一点点面子:D

http://winice.yeah.net/
http://coobe.cs.hn.cninfo.net/~tianwei
spring_w@263.net

