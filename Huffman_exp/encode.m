%获取编码映射表
function [a]=encode(p)
[~,n]=size(p);%得到编码个数
HT=zeros(2*n-1,4);%构造Huffman树

for i=1:n
    HT(i,1)=p(i);
end
HT;
%第一列为个数的权重值 1~4列分别为  权重  父节点  左孩子  右孩子
HT0=HT;

%构建Huffman树
for i=1:n-1
         a=HT0(:,1);
         [b,l]=sort(a,'descend');%递减排序
         s=b(n-i+1)+b(n-i);%选取两个最小值进行求和 大 小
         HT0(n+i,1)=s;%将求和后的数放进Huffman树的父节点上
         HT0(l(n-i+1),1)=0;%将两个最小值删除，清零
         HT0(l(n-i),1)=0;
         
         HT0(l(n-i+1),2)=n+i;%设置为两个最小值的父节点 
         HT0(l(n-i),2)=n+i;
         
         HT0(n+i,3)=l(n-i+1);%父节点的左孩子
         HT0(n+i,4)=l(n-i);%父节点的右孩子   
         
         %重构Huffman树
         HT(n+i,1)=s;
         HT(l(n-i+1),2)=n+i;
         HT(l(n-i),2)=n+i;
         HT(n+i,3)=l(n-i+1);
         HT(n+i,4)=l(n-i); 
end

%字符数组，用于生成Huffman码
a={;};
for i=1:n
    a{1,i}=' ';
end 

%Huffman编码
for i=1:n
    f=i;
    while(HT(f,2)~=0)%直到父节点为根结点时，编码完成
        q=HT(f,2);%取出叶子结点的父节点的值
        
        if HT(q,3)==f
            a{i}=strcat('0',a{i});%若为左孩子，则编为0
        else
            a{i}=strcat('1',a{i});%若为右孩子，则编为1
        end
        f=q;%继续寻找父节点的节点
    end   
end
end