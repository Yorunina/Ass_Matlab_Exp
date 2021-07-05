function [y_out]=raylChan(msg,N,fc,fm,delay,power)

len = length(delay);
y_in = [zeros(1,delay(len)) msg];
y_out = zeros(1,N);
for i = 1:len
    f = 1:2*fm-1;%ͨƵ������
    y = 0.5./((1-((f-fm)/fm).^2).^(1/2))/pi;%�����չ�����
    Sf = zeros(1,N);
    Sf1 = y;%�������˲�����Ƶ����Ӧ
    Sf(fc-fm+1:fc+fm-1) = y;%���������ز�Ƶ�ʵ�ӳ��
    
    x1 = randn(1,N);
    x2 = randn(1,N);
    nc = ifft(fft(x1+i*x2).*sqrt(Sf));%ͬ�����
    
    x3 = randn(1,N);
    x4 = randn(1,N);
    ns = ifft(fft(x3+i*x4).*sqrt(Sf));%��������
    
    r0 = (real(nc)+1i*real(ns));%�����ź�
    r = abs(r0);%����ֵ
    
    y_out = y_out+r.*y_in(delay(len)+1-delay(i):delay(len)+N-delay(i))*10^(power(i)/20);
end