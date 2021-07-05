function [y_out]=raylChan(msg,N,fc,fm,delay,power)

len = length(delay);
y_in = [zeros(1,delay(len)) msg];
y_out = zeros(1,N);
for i = 1:len
    f = 1:2*fm-1;%通频带长度
    y = 0.5./((1-((f-fm)/fm).^2).^(1/2))/pi;%多普勒功率谱
    Sf = zeros(1,N);
    Sf1 = y;%多普勒滤波器的频率响应
    Sf(fc-fm+1:fc+fm-1) = y;%基带对于载波频率的映射
    
    x1 = randn(1,N);
    x2 = randn(1,N);
    nc = ifft(fft(x1+i*x2).*sqrt(Sf));%同相分量
    
    x3 = randn(1,N);
    x4 = randn(1,N);
    ns = ifft(fft(x3+i*x4).*sqrt(Sf));%正交分量
    
    r0 = (real(nc)+1i*real(ns));%瑞利信号
    r = abs(r0);%幅度值
    
    y_out = y_out+r.*y_in(delay(len)+1-delay(i):delay(len)+N-delay(i))*10^(power(i)/20);
end