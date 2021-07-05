clear
%data = input('输入需要编码的字符串：\n','s');

%读入txt
data=fileread('input.txt');

%读入word，这是一种极其古老的方法，在现有的office(2016往后)已不支持，解决方法是通过使用外部程序将doc处理为txt
% f = [ '.doc'];
% try   
%     Word = actxGetRunningServer('Word.Application');  %启动word引擎
% catch   
%     Word = actxserver('Word.Application');
% end
% Word.Visible = 1;    % 或set(Word, 'Visible', 1);   %设置可见
% if exist(f,'file')    %测试文件存在的话
%     Document = Word.Documents.Open(f);      %获得文档的对象Document
% else                %不存在则创建添加
%     Document = Word.Documents.Add;      
%     Document.SaveAs(f);        %保存文档
% end
% Selection = Word.Selection;               %光标所在处
% Selection.Start=0;
% a=[];
% num=Document.Range.end;
% ii=0;
% while ii<=num
%     ii=ii+1;
%     a=[a,Selection.text];
%     Selection.MoveRight;     %光标向右移动一格
% end
% data = num2str(a(1:num));
% 取文本有内容的部分

ascii_data = abs(data);
%获取原本长度
ori_L = 0;
for i = 1:length(ascii_data)
    ori_L = length(dec2bin(ascii_data(i))) + ori_L;
end
%编码
[encode_data, coder, key_name] = encode_output(data);
%加错
[wcode_data,wt]= BSC_channel(encode_data,0.01);
fprintf('经过BSC信道后得到编码信息为%s，出错率为%f\n',wcode_data,wt/length(wcode_data))
decode_data = decode_output(wcode_data, coder, key_name);
%获取压缩后长度
L = length(encode_data);
%输出解码结果进行比较
fprintf('因此 %s 的译码结果为 %s\n',data,decode_data);
fprintf('未压缩长度为%i，压缩长度为%i，压缩比为%f\n',ori_L,L,L/ori_L)
%可将编码结果输出为txt
fid=fopen('output.txt','at+');%打开txt文件
fprintf(fid,encode_data);
fclose(fid);
