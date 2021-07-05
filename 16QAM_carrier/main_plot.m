clear;clc;echo off;close all;
M = 10000;               %�趨��Ԫ����
N = 4*M;                %��Ӧ16QAM��������
fb=4; 	               %�����ź�Ƶ��
fs=32*fb;                 %����Ƶ��
fc=4*fb;  	               %�ز�Ƶ��
Kbase=2;               % Kbase=1,�������������˲���ֱ�ӵ���; 
                       % Kbase=2,�����������˲����˲����ٽ��е���
type_cha = {'gray','sp','msp','msew'};             %gray\sp\msp\msew
info=random_binary(N);               %���������������������
%�����Ԫ���У��������Ա�
for i = 1:M
    dec_info(i) = bin2dec(num2str(info(i:i+3)));
end

SNR_in_dB=-10:2:22;                     %AWGN�ŵ������
for i = 1:4
    type = type_cha{i};
    [y,I,Q]=qam(info,Kbase,fs,fb,fc,type);    %�Ի����źŽ���16QAM����
    y1=y;  y2=y;                         %�����źţ�������������
    T=length(info)/fb; 
    m=fs/fb;	
    nn=length(info);
    dt=1/fs;          
    t=0:dt:T-dt;   

    n=length(y);
    y=fft(y)/n;    
    y=abs(y(1:fix(n/2)))*2;
    q=find(y<1e-04);
    y(q)=1e-04;    
    y=20*log10(y);
    f1=m/n;        
    f=0:f1:(length(y)-1)*f1;
    %subplot(212);	
    % plot(f,y,'b');	
    % grid on;  
    % title('�ѵ��ź�Ƶ��'); 	xlabel('f/fb'); 
    %����16QAM���Ʒ�ʽ��Ӧ������ͼ
    %constel(y1,fs,fb,fc); 
    %title('����ͼ');

    %����ز��ź�
    % figure;
    % plot((1:10000).',y1(1:10000));

    % Ts=1/fs;            %�������
    % Fd=480;              %DopplerƵƫ����HzΪ��λ
    % tau=[0,0.02];          %�ྶ��ʱ����sΪ��λ
    % pdf=[0,-20];          %�������ʣ���dBλ��λ
    % chan=rayleighchan(Ts,Fd,tau,pdf);
    % y2 = filter(chan,y2);

    %�����ŵ�
    % fm = 1024; %��������Ƶ��
    % delay = [0 30 71 109 173 251];%�ྶ�ź�ʱ��
    % power = [5 -10 -20 -30 -50 -80];%�ྶ�ź�˥��
    % y2 = raylChan(y2,32*N,fc,fm,delay,power);

    for j=1:length(SNR_in_dB)
        y_add_noise=awgn(y1,SNR_in_dB(j)); %���벻ͬǿ�ȵĸ�˹������
        y_output=qamdet(y_add_noise,fs,fb,fc,type);      %���ѵ��źŽ��н��
        err_chun = xor(y_output,info);
        Pe(i,j)=sum(err_chun == 1)/N;                 %ͳ���������
        for t = 1:M
            dec_output(t) = bin2dec(num2str(y_output(t:t+3)));
        end
        err_chun = abs(dec_output-dec_info);
        Pc(i,j) =sum(err_chun ~= 0)/M;
    end
end

% snr1=10.^(EsN0/10);%��dbת��Ϊ����ֵ
% M = 16;
% p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
% ser_theory=1-(1-p).^2;%16QAM����������
% ber_theory=1/log2(M)*ser_theory;

% for i = 1:4
%     y = Pe(i,:);
%     p4 = polyfit(SNR_in_dB,y,5);
%     pw(i,:) = polyval(p4,SNR_in_dB);
% end
figure;
semilogy(SNR_in_dB,Pe(1,:),'blue',SNR_in_dB,Pe(2,:),'red',SNR_in_dB,Pe(3,:),'green',SNR_in_dB,Pe(4,:),'black');
legend('gray','sp','msp','msew')
xlim([-10,22])
grid on;
xlabel('SNR in dB'); 
ylabel('Pe');
title("16QAM���ز��ź���AWGN�ŵ��µ��������")

figure;
semilogy(SNR_in_dB,Pc(1,:),'blue',SNR_in_dB,Pc(2,:),'red',SNR_in_dB,Pc(3,:),'green',SNR_in_dB,Pc(4,:),'black');
legend('gray','sp','msp','msew')
xlim([-10,22])
grid on;
xlabel('SNR in dB'); 
ylabel('Pc');
title("16QAM���ز��ź���AWGN�ŵ��µ�������")