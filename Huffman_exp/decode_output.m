function decode_data = decode_output(encode_data, coder, key_name)
%�����滻
decode_data = '';
sub_data = '';
%�����ַ���ƴ�ӱ����滻���õ�������
for i=1:length(encode_data)
    sub_data = [sub_data,encode_data(i)]; 
    member_site = find(strcmp(coder,sub_data));
    if isempty(member_site)==0
        decode_data = [decode_data,key_name{member_site}];
        sub_data = '';
    end
end
end
