function [encode_data, coder, key_name] = encode_output(data)
symbol_cmap = containers.Map;%符号个数字典
all_len = length(data);%存储总长度方便后续调用
%单次遍历统计每个字符出现次数
for i=1:all_len
    if symbol_cmap.isKey(data(i))
        symbol_cmap(data(i)) = symbol_cmap(data(i)) + 1;
    else
        symbol_cmap(data(i))=1;
    end
end
key_name = symbol_cmap.keys;
%计算对应字符概率和信息熵
H = 0;
for i=1:length(key_name)
    p(i) = symbol_cmap(key_name{i})/all_len;
    H = -p(i)*log2(p(i)) + H;
end

%获取编码对照表，建立huffman树
coder = encode(p);
%输出编码对照表结果和平均码长
L = 0;
for i=1:length(key_name)
    L = p(i)*length(coder{i})+L;
    fprintf('%s (%f) 对应的编码为 %s\n',key_name{i},p(i),coder{i})

end
fprintf('平均码长为%f\n信息熵为%f\n' , L, H)
encode_data = data;
%替换原有文本，得到编码结果
for i=1:length(key_name)
    encode_data = strrep(encode_data,key_name{i},coder{i});
end
%输出编码结果
fprintf('因此编码结果为 %s\n',encode_data);
end