clear;
close all;
code =round(rand(1,32));
%编码
[hamming_code,add_hamming_code] = hamming_encode(code);


%加错
%BSC信道
[w_add_hamming_code,wt] = BSC_channel(add_hamming_code,0.1);
%高斯白噪声信道
% snr=12;
% w_add_hamming_code=awgn(add_hamming_code,snr);
% for i=1:length(w_add_hamming_code)
%     if(abs(w_add_hamming_code(i))<0.5)
%         w_add_hamming_code(i)=0;
%     else
%         w_add_hamming_code(i)=1;
%     end
% end


%解码
add_w = sum(xor(w_add_hamming_code,add_hamming_code)== 1);
output = hamming_decode(w_add_hamming_code);
fprintf('其输入比特为：\n%s\n输出比特为：\n%s\n',num2str(code),num2str(output))
last_w = sum(xor(code,output)== 1);
fprintf('信道加错%i位\n其误比特率为：%f\n出错个数为：%i\n', add_w, last_w/length(code), last_w)