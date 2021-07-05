clear;clc;echo off;close all;
%test
SYI = fopen('test2021_2_8_I.bin', 'r'); %打开数据I路
SYQ = fopen('test2021_2_8_Q.bin', 'r');%打开数据Q路
dataI = fread(SYI, 'int16').'; %读取数据I路
dataQ = fread(SYQ, 'int16').'; %读取数据Q路
fclose(SYI);
fclose(SYQ);
data1 = dataI + dataQ.*1i;

M=16;%M表示QAM调制的阶数,表示16QAM，16QAM采用格雷映射(所有星座点图均采用格雷映射)

type_cha = {'gray','sp','msp','msew'};             %gray\sp\msp\msew

for j = 1:4
    type = type_cha{j};
    switch type
        case 'gray'
            T = [0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];
            DT = [0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];
        case 'sp'
            T = [8 13 12 9 15 10 11 14 4 1 0 5 3 6 7 2];
            DT =[10 9 15 12 8 11 13 14 0 3 5 6 2 1 7 4];
        case 'msp'
            T = [8 11 12 15 1 2 5 6 4 7 0 3 13 14 9 10];
            DT =[10 4 5 11 8 6 7 9 0 14 15 1 2 12 13 3];
        case 'msew'
            T = [15 1 6 8 2 12 11 5 9 7 0 14 4 10 13 3];
            DT =[10 1 4 15 12 7 2 9 3 8 13 6 5 14 11 0];
    end
    %解调
    y=qamdemod(data1,M);
    %接收端逆映射，返回译码十进制信息
    decmsg(j,:)=DT(y+1);
end

[m,n] = size(decmsg);
figure();
plot(1:n,decmsg(1,:))