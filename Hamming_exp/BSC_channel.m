function [encode_data,wt]= BSC_channel(encode_data, p)
wt = 0;
for i=1:length(encode_data)
    if rand<p
        encode_data(i) = mod(encode_data(i)+1, 2);
        wt = wt + 1;
    end
end
end