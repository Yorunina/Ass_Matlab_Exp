function output = hamming_decode(code)
add_flag = code(end);
code = code(1:end-1);
code_len = length(code);
% ����Ϣλ���Ⱥͼලλ����
flag_len = 0;
while 2^flag_len < code_len
    flag_len = flag_len + 1;
end
data_len = code_len - flag_len;

% �ж���żУ��λ������ż�Բ�����
for i = 1:flag_len
    this_flag_pos = 2^(i - 1);
    temp = 0;
    for j = this_flag_pos:2^i:code_len
        for index = j:min(j+2^(i-1)-1, code_len)
            temp = xor(temp, code(index));
        end
    end
    if temp == 1
        wrong(i) = '1';
    else
        wrong(i) = '0';
    end
end
% ��λ������Ԫλ�ò�����
wrong = reverse(wrong);
wrong_index = bin2dec(wrong);
if wrong_index ~= 0
    %����Ƿ���λ����
    if add_flag == mod(sum(code(:)==1),2)
    fprintf('��⵽������λ����\n')
    elseif wrong_index<code_len
        code(wrong_index) = ~code(wrong_index);
        fprintf('���ڵ�λ��������λ��Ϊ%i�����Զ�������\n',wrong_index)
    else
        fprintf('���ڳ�������ά�ȵĶ������\n')
    end
end



for i = 1:flag_len
    flag_index(i) = 2^(i-1);
end

index = 0;
i = 1;
while index < code_len
    index = index + 1;
    if ismember(index, flag_index)
        continue
    else
        output(i) = code(index);
        i = i + 1;
    end
end
end
