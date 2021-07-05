function [hamming_code,add_hamming_code] = hamming_encode(data)
% ��Ϣλ����
data_len = length(data);

% ��ලλ����flag_len
flag_len = 0;
while 2^flag_len - flag_len - 1 < data_len
    flag_len = flag_len + 1;
    flag_index(flag_len) = 2^(flag_len - 1);
end

% ���볤
code_len = data_len + flag_len;

% ��ʼ����Ԫ����
hamming_code = zeros(1, code_len);

% ����Դ��Ԫ
index = 1;
i = 1;
while index <= code_len
    if ismember(index, flag_index)
        index = index + 1;
    else
        hamming_code(index) = data(i);
        index = index + 1;
        i = i + 1;
    end
end

% �жϼලλ��ֵ
for i = 1:flag_len
    this_flag_pos = 2^(i - 1);
    temp = 0;
    for j = this_flag_pos:2^i:code_len
        for index = j:min(j+2^(i-1)-1, code_len)
            temp = xor(temp, hamming_code(index));
        end
    end
    if temp == 1
        hamming_code(this_flag_pos) = 1;
    end
end

%�����຺��λ�����
add_flag = mod(sum(hamming_code(:)==1),2);
add_hamming_code = [hamming_code add_flag];
end
