%QAM�źŽ��
function xn=qamdet(y,fs,fb,fc,type)
dt=1/fs; t=0:dt:(length(y)-1)*dt;
I=y.*cos(2*pi*fc*t);
Q=-y.*sin(2*pi*fc*t);
[b,a]=butter(2,2*fb/fs);  %��ư�����˹�˲���
I=filtfilt(b,a,I);
Q=filtfilt(b,a,Q);
m=4*fs/fb;
N=length(y)/m;
n=(.6:1:N)*m;
n=fix(n);
In=I(n);
Qn=Q(n);
[I_out,Q_out] =four2two(In,Qn,type);  
%I����Q������/��ת�������ջָ�����Ԫ����xn
xn=[I_out;Q_out]; 
xn=xn(:);
xn=xn';

end
