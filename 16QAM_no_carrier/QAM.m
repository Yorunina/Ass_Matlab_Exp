clear;clc;echo off;close all;
nsymbol=10000;%表示一共有多少个符号，这里定义10000个符号
M=16;%M表示QAM调制的阶数,表示16QAM，16QAM采用格雷映射(所有星座点图均采用格雷映射)

type_cha = {'gray','sp','msp','msew'};             %gray\sp\msp\msew

EsN0=0:18;%信噪比范围
snr1=10.^(EsN0/10);%将db转换为线性值
msg=randi([0,M-1],1,nsymbol);%0到15之间随机产生一个数,数的个数为：1乘nsymbol，得到原始数据

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

    
    msg1=T(msg+1);%对数据进行映射
    msgmod=qammod(msg1,M);

    %scatterplot(msgmod);%调用matlab中的scatterplot函数,画星座点图
    %取a+bj的模.^2得到功率除整个符号得到每个符号的平均功率
    spow=norm(msgmod).^2/nsymbol;
    %Tsamp采样周期(1/Fs)、Tsym符号周期(1/Rs)
    %Es/N0(dB) = 10log10(0.5*Tsym/Tsamp)+SNR(dB)实信号
    %Es/N0(dB) = 10log10(Tsym/Tsamp)+SNR(dB)复信号
    for i=1:length(EsN0)
       %根据符号功率求出噪声的功率
       sigma=sqrt(spow/(2*snr1(i)));
       %混入高斯加性白噪声
       rx=msgmod+sigma*(randn(1,length(msgmod))+1i*randn(1,length(msgmod)));
       %解调
       y=qamdemod(rx,M);
       %接收端逆映射，返回译码十进制信息
       decmsg=DT(y+1);
       [err1,ber(j,i)]=biterr(msg,decmsg,log2(M));%误比特率
       [err2,ser(j,i)]=symerr(msg,decmsg);%误码率
    end
    %scatterplot(rx);%调用matlab中的scatterplot函数,画rx星座点图
end
p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser_theory=1-(1-p).^2;%16QAM理论误码率
ber_theory=1/log2(M)*ser_theory;
%绘图
figure()
semilogy(EsN0,ber(1,:),EsN0,ber(2,:),EsN0,ber(3,:),EsN0,ber(4,:), EsN0, ber_theory);
xlabel("EsN0");
ylabel("Pe");
grid on;
title("16QAM无载波信号在AWGN信道下的误比特率");
legend('gray','sp','msp','msew','理论误比特率');

figure()
semilogy(EsN0,ser(1,:),EsN0,ser(2,:),EsN0,ser(3,:),EsN0,ser(4,:),EsN0, ser_theory);
xlabel("EsN0");
ylabel("Pc");
grid on;
title("16QAM无载波信号在AWGN信道下的误码率");
legend('gray','sp','msp','msew','理论误码率');
