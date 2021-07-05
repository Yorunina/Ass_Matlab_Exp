function decode_data = decode_output(encode_data, coder, key_name)
%解码替换
decode_data = '';
sub_data = '';
%进行字符串拼接遍历替换，得到解码结果
for i=1:length(encode_data)
    sub_data = [sub_data,encode_data(i)]; 
    member_site = find(strcmp(coder,sub_data));
    if isempty(member_site)==0
        decode_data = [decode_data,key_name{member_site}];
        sub_data = '';
    end
end
end
