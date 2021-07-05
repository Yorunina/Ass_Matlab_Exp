function [encode_data, coder, key_name] = encode_output(data)
symbol_cmap = containers.Map;%���Ÿ����ֵ�
all_len = length(data);%�洢�ܳ��ȷ����������
%���α���ͳ��ÿ���ַ����ִ���
for i=1:all_len
    if symbol_cmap.isKey(data(i))
        symbol_cmap(data(i)) = symbol_cmap(data(i)) + 1;
    else
        symbol_cmap(data(i))=1;
    end
end
key_name = symbol_cmap.keys;
%�����Ӧ�ַ����ʺ���Ϣ��
H = 0;
for i=1:length(key_name)
    p(i) = symbol_cmap(key_name{i})/all_len;
    H = -p(i)*log2(p(i)) + H;
end

%��ȡ������ձ�����huffman��
coder = encode(p);
%���������ձ�����ƽ���볤
L = 0;
for i=1:length(key_name)
    L = p(i)*length(coder{i})+L;
    fprintf('%s (%f) ��Ӧ�ı���Ϊ %s\n',key_name{i},p(i),coder{i})

end
fprintf('ƽ���볤Ϊ%f\n��Ϣ��Ϊ%f\n' , L, H)
encode_data = data;
%�滻ԭ���ı����õ�������
for i=1:length(key_name)
    encode_data = strrep(encode_data,key_name{i},coder{i});
end
%���������
fprintf('��˱�����Ϊ %s\n',encode_data);
end