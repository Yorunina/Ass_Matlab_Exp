function [I,Q,In,Qn]=two2four(x,m,type)
%翻译码表选择
nn=length(x);
I=x(1:2:nn-1);	
Q=x(2:2:nn);

%对同相和正交通道分别构建编码映射表
switch type
    case 'gray'
        TI = [0 1 3 2;0 1 3 2;0 1 3 2;0 1 3 2];
        TQ = [0 0 0 0;1 1 1 1;3 3 3 3;2 2 2 2];
    case 'sp'
        TI = [0 1 0 1;3 2 3 2;0 1 0 1;3 2 3 2];
        TQ = [2 3 3 2;3 2 2 3;1 0 0 1;0 1 1 0];
    case 'msp'
        TI = [0 3 0 3;1 2 1 2;0 3 0 3;1 2 1 2];
        TQ = [2 2 3 3;0 0 1 1;1 1 0 0;3 3 2 2];
    case 'msew'
        TI = [3 1 2 0;2 0 3 1;1 3 0 2;0 2 1 3];
        TQ = [3 0 1 2;0 3 2 1;2 1 0 3;1 2 3 0];
end

%对两通道同时进行映射
n=length(I);
ii=1;
for i=1:2:n-1
   Ii=I(i:i+1);
   Qi=Q(i:i+1);
   Ii = 2*Ii(1)+Ii(2)+1;
   Qi = 2*Qi(1)+Qi(2)+1;
   In(ii)=TI(Qi,Ii);
   Qn(ii)=TQ(Qi,Ii); 
   ii=ii+1;
end
%统一调整电平值
%映射电平分别为-1.5；-0.5；0.5；1.5
In=In-1.5;
I=In;
Qn=Qn-1.5;
Q=Qn;
for i=1:m-1
    I=[I;In];
    Q=[Q;Qn];
end
I=I(:)';
Q=Q(:)';
end