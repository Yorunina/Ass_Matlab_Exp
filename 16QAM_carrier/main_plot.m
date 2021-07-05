clear;clc;echo off;close all;
M = 10000;               %设定码元数量
N = 4*M;                %对应16QAM比特数量
fb=4; 	               %基带信号频率
fs=32*fb;                 %抽样频率
fc=4*fb;  	               %载波频率
Kbase=2;               % Kbase=1,不经基带成形滤波，直接调制; 
                       % Kbase=2,基带经成形滤波器滤波后，再进行调制
type_cha = {'gray','sp','msp','msew'};             %gray\sp\msp\msew
info=random_binary(N);               %产生二进制随机比特序列
%获得码元序列，供后续对比
for i = 1:M
    dec_info(i) = bin2dec(num2str(info(i:i+3)));
end

SNR_in_dB=-10:2:22;                     %AWGN信道信噪比
for i = 1:4
    type = type_cha{i};
    [y,I,Q]=qam(info,Kbase,fs,fb,fc,type);    %对基带信号进行16QAM调制
    y1=y;  y2=y;                         %备份信号，供后续仿真用
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
    % title('已调信号频谱'); 	xlabel('f/fb'); 
    %画出16QAM调制方式对应的星座图
    %constel(y1,fs,fb,fc); 
    %title('星座图');

    %输出载波信号
    % figure;
    % plot((1:10000).',y1(1:10000));

    % Ts=1/fs;            %采样间隔
    % Fd=480;              %Doppler频偏，以Hz为单位
    % tau=[0,0.02];          %多径延时，以s为单位
    % pdf=[0,-20];          %各径功率，以dB位单位
    % chan=rayleighchan(Ts,Fd,tau,pdf);
    % y2 = filter(chan,y2);

    %瑞利信道
    % fm = 1024; %最大多普勒频移
    % delay = [0 30 71 109 173 251];%多径信号时延
    % power = [5 -10 -20 -30 -50 -80];%多径信号衰弱
    % y2 = raylChan(y2,32*N,fc,fm,delay,power);

    for j=1:length(SNR_in_dB)
        y_add_noise=awgn(y1,SNR_in_dB(j)); %加入不同强度的高斯白噪声
        y_output=qamdet(y_add_noise,fs,fb,fc,type);      %对已调信号进行解调
        err_chun = xor(y_output,info);
        Pe(i,j)=sum(err_chun == 1)/N;                 %统计误比特率
        for t = 1:M
            dec_output(t) = bin2dec(num2str(y_output(t:t+3)));
        end
        err_chun = abs(dec_output-dec_info);
        Pc(i,j) =sum(err_chun ~= 0)/M;
    end
end

% snr1=10.^(EsN0/10);%将db转换为线性值
% M = 16;
% p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
% ser_theory=1-(1-p).^2;%16QAM理论误码率
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
title("16QAM有载波信号在AWGN信道下的误比特率")

figure;
semilogy(SNR_in_dB,Pc(1,:),'blue',SNR_in_dB,Pc(2,:),'red',SNR_in_dB,Pc(3,:),'green',SNR_in_dB,Pc(4,:),'black');
legend('gray','sp','msp','msew')
xlim([-10,22])
grid on;
xlabel('SNR in dB'); 
ylabel('Pc');
title("16QAM有载波信号在AWGN信道下的误码率")