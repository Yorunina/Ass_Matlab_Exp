clear
%data = input('������Ҫ������ַ�����\n','s');

%����txt
data=fileread('input.txt');

%����word������һ�ּ�����ϵķ����������е�office(2016����)�Ѳ�֧�֣����������ͨ��ʹ���ⲿ����doc����Ϊtxt
% f = [ '.doc'];
% try   
%     Word = actxGetRunningServer('Word.Application');  %����word����
% catch   
%     Word = actxserver('Word.Application');
% end
% Word.Visible = 1;    % ��set(Word, 'Visible', 1);   %���ÿɼ�
% if exist(f,'file')    %�����ļ����ڵĻ�
%     Document = Word.Documents.Open(f);      %����ĵ��Ķ���Document
% else                %�������򴴽����
%     Document = Word.Documents.Add;      
%     Document.SaveAs(f);        %�����ĵ�
% end
% Selection = Word.Selection;               %������ڴ�
% Selection.Start=0;
% a=[];
% num=Document.Range.end;
% ii=0;
% while ii<=num
%     ii=ii+1;
%     a=[a,Selection.text];
%     Selection.MoveRight;     %��������ƶ�һ��
% end
% data = num2str(a(1:num));
% ȡ�ı������ݵĲ���

ascii_data = abs(data);
%��ȡԭ������
ori_L = 0;
for i = 1:length(ascii_data)
    ori_L = length(dec2bin(ascii_data(i))) + ori_L;
end
%����
[encode_data, coder, key_name] = encode_output(data);
%�Ӵ�
[wcode_data,wt]= BSC_channel(encode_data,0.01);
fprintf('����BSC�ŵ���õ�������ϢΪ%s��������Ϊ%f\n',wcode_data,wt/length(wcode_data))
decode_data = decode_output(wcode_data, coder, key_name);
%��ȡѹ���󳤶�
L = length(encode_data);
%������������бȽ�
fprintf('��� %s ��������Ϊ %s\n',data,decode_data);
fprintf('δѹ������Ϊ%i��ѹ������Ϊ%i��ѹ����Ϊ%f\n',ori_L,L,L/ori_L)
%�ɽ����������Ϊtxt
fid=fopen('output.txt','at+');%��txt�ļ�
fprintf(fid,encode_data);
fclose(fid);
