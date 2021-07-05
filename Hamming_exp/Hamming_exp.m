clear;
close all;
code =round(rand(1,32));
%����
[hamming_code,add_hamming_code] = hamming_encode(code);


%�Ӵ�
%BSC�ŵ�
[w_add_hamming_code,wt] = BSC_channel(add_hamming_code,0.1);
%��˹�������ŵ�
% snr=12;
% w_add_hamming_code=awgn(add_hamming_code,snr);
% for i=1:length(w_add_hamming_code)
%     if(abs(w_add_hamming_code(i))<0.5)
%         w_add_hamming_code(i)=0;
%     else
%         w_add_hamming_code(i)=1;
%     end
% end


%����
add_w = sum(xor(w_add_hamming_code,add_hamming_code)== 1);
output = hamming_decode(w_add_hamming_code);
fprintf('���������Ϊ��\n%s\n�������Ϊ��\n%s\n',num2str(code),num2str(output))
last_w = sum(xor(code,output)== 1);
fprintf('�ŵ��Ӵ�%iλ\n���������Ϊ��%f\n�������Ϊ��%i\n', add_w, last_w/length(code), last_w)