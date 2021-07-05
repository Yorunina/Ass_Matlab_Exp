function [y,I,Q]=qam(x,Kbase,fs,fb,fc,type)
%
T=length(x)/fb;
m=fs/fb;
nn=length(x);
dt=1/fs;
t=0:dt:T-dt;
%串/并变换分离出I分量、Q分量，然后再分别进行电平映射
[I,Q,In,Qn]=two2four(x,4*m,type);  
if Kbase==2        %基带成形滤波
   I=bshape(I,fs,fb/4);
   Q=bshape(Q,fs,fb/4); 
end
y=I.*cos(2*pi*fc*t)-Q.*sin(2*pi*fc*t);