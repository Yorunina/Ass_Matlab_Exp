%��ȡ����ӳ���
function [a]=encode(p)
[~,n]=size(p);%�õ��������
HT=zeros(2*n-1,4);%����Huffman��

for i=1:n
    HT(i,1)=p(i);
end
HT;
%��һ��Ϊ������Ȩ��ֵ 1~4�зֱ�Ϊ  Ȩ��  ���ڵ�  ����  �Һ���
HT0=HT;

%����Huffman��
for i=1:n-1
         a=HT0(:,1);
         [b,l]=sort(a,'descend');%�ݼ�����
         s=b(n-i+1)+b(n-i);%ѡȡ������Сֵ������� �� С
         HT0(n+i,1)=s;%����ͺ�����Ž�Huffman���ĸ��ڵ���
         HT0(l(n-i+1),1)=0;%��������Сֵɾ��������
         HT0(l(n-i),1)=0;
         
         HT0(l(n-i+1),2)=n+i;%����Ϊ������Сֵ�ĸ��ڵ� 
         HT0(l(n-i),2)=n+i;
         
         HT0(n+i,3)=l(n-i+1);%���ڵ������
         HT0(n+i,4)=l(n-i);%���ڵ���Һ���   
         
         %�ع�Huffman��
         HT(n+i,1)=s;
         HT(l(n-i+1),2)=n+i;
         HT(l(n-i),2)=n+i;
         HT(n+i,3)=l(n-i+1);
         HT(n+i,4)=l(n-i); 
end

%�ַ����飬��������Huffman��
a={;};
for i=1:n
    a{1,i}=' ';
end 

%Huffman����
for i=1:n
    f=i;
    while(HT(f,2)~=0)%ֱ�����ڵ�Ϊ�����ʱ���������
        q=HT(f,2);%ȡ��Ҷ�ӽ��ĸ��ڵ��ֵ
        
        if HT(q,3)==f
            a{i}=strcat('0',a{i});%��Ϊ���ӣ����Ϊ0
        else
            a{i}=strcat('1',a{i});%��Ϊ�Һ��ӣ����Ϊ1
        end
        f=q;%����Ѱ�Ҹ��ڵ�Ľڵ�
    end   
end
end