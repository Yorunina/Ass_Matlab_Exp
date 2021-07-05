function  [I_out,Q_out]=four2two(I,Q,type)
In=I; Imin=min(I); Imax=max(I); Imax=max([Imax abs(Imin)]);
Imin=-abs(Imax);   In=(I-Imin)*3/(Imax-Imin); 

Qn=Q; Qmin=min(Q); Qmax=max(Q); Qmax=max([Qmax abs(Qmin)]);
Qmin=-abs(Qmax);   Qn=(Q-Qmin)*3/(Qmax-Qmin); 

%构造解调映射表
switch type
    case 'gray'
        T = [11 12 14 13;21 22 24 23;41 42 44 43;31 32 34 33];
    case 'sp'
        T = [31 42 41 32;44 33 34 43;21 12 11 22;14 23 24 13];
    case 'msp'
        T = [31 34 41 44;12 13 22 23;21 24 11 14;42 43 32 33];
    case 'msew'
        T = [44 12 23 31;13 41 34 22;32 24 11 43;21 33 42 14];
end

%设置门限电平，进行判决
I0=find(In< 0.5);
In(I0)=zeros(size(I0));

I1=find(In>=0.5 & In<1.5);
In(I1)=ones(size(I1));

I2=find(In>=1.5 & In<2.5);
In(I2)=ones(size(I2))*2;

I3=find(In>=2.5);
In(I3)=ones(size(I3))*3;

Q0=find(Qn< 0.5);
Qn(Q0)=zeros(size(Q0));

Q1=find(Qn>=0.5 & Qn<1.5);
Qn(Q1)=ones(size(Q1));

Q2=find(Qn>=1.5 & Qn<2.5);
Qn(Q2)=ones(size(Q2))*2;

Q3=find(Qn>=2.5);
Qn(Q3)=ones(size(Q3))*3;
num_cha = [0 0;0 1;1 0;1 1];
%一位四进制码元转换为两位二进制码元
n=length(In); 
I_out = []; Q_out = [];
for i=1:n
   site_num = In(i) + Qn(i)*10 + 11;
   site = find(T == site_num);
   I_out = [I_out num_cha(floor((site-1)/4)+1,:)];
   Q_out = [Q_out num_cha(mod((site-1),4)+1,:)];
end
end