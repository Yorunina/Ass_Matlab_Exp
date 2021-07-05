clear;clc;echo off;close all;
nsymbol=10000;%��ʾһ���ж��ٸ����ţ����ﶨ��10000������
M=16;%M��ʾQAM���ƵĽ���,��ʾ16QAM��16QAM���ø���ӳ��(����������ͼ�����ø���ӳ��)

type_cha = {'gray','sp','msp','msew'};             %gray\sp\msp\msew

EsN0=0:18;%����ȷ�Χ
snr1=10.^(EsN0/10);%��dbת��Ϊ����ֵ
msg=randi([0,M-1],1,nsymbol);%0��15֮���������һ����,���ĸ���Ϊ��1��nsymbol���õ�ԭʼ����

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

    
    msg1=T(msg+1);%�����ݽ���ӳ��
    msgmod=qammod(msg1,M);

    %scatterplot(msgmod);%����matlab�е�scatterplot����,��������ͼ
    %ȡa+bj��ģ.^2�õ����ʳ��������ŵõ�ÿ�����ŵ�ƽ������
    spow=norm(msgmod).^2/nsymbol;
    %Tsamp��������(1/Fs)��Tsym��������(1/Rs)
    %Es/N0(dB) = 10log10(0.5*Tsym/Tsamp)+SNR(dB)ʵ�ź�
    %Es/N0(dB) = 10log10(Tsym/Tsamp)+SNR(dB)���ź�
    for i=1:length(EsN0)
       %���ݷ��Ź�����������Ĺ���
       sigma=sqrt(spow/(2*snr1(i)));
       %�����˹���԰�����
       rx=msgmod+sigma*(randn(1,length(msgmod))+1i*randn(1,length(msgmod)));
       %���
       y=qamdemod(rx,M);
       %���ն���ӳ�䣬��������ʮ������Ϣ
       decmsg=DT(y+1);
       [err1,ber(j,i)]=biterr(msg,decmsg,log2(M));%�������
       [err2,ser(j,i)]=symerr(msg,decmsg);%������
    end
    %scatterplot(rx);%����matlab�е�scatterplot����,��rx������ͼ
end
p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser_theory=1-(1-p).^2;%16QAM����������
ber_theory=1/log2(M)*ser_theory;
%��ͼ
figure()
semilogy(EsN0,ber(1,:),EsN0,ber(2,:),EsN0,ber(3,:),EsN0,ber(4,:), EsN0, ber_theory);
xlabel("EsN0");
ylabel("Pe");
grid on;
title("16QAM���ز��ź���AWGN�ŵ��µ��������");
legend('gray','sp','msp','msew','�����������');

figure()
semilogy(EsN0,ser(1,:),EsN0,ser(2,:),EsN0,ser(3,:),EsN0,ser(4,:),EsN0, ser_theory);
xlabel("EsN0");
ylabel("Pc");
grid on;
title("16QAM���ز��ź���AWGN�ŵ��µ�������");
legend('gray','sp','msp','msew','����������');
