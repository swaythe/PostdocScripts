function [NewData] = fget_null(Data, blocklen)

% Do a block-wise scrambling of the timeseries data. I'm going to start
% with replacing the front and back of the timeseries with each other and
% try a more random scrambling later to see what the difference is.

NewData = zeros(length(Data),1);
bExtra = mod(length(Data), blocklen);
if bExtra == 0
    bEnd = length(Data);
    even = 1;
else
    bEnd = length(Data) - bExtra;
    even = 0;
end

p1 = floor(blocklen/2);
p2 = blocklen - p1;

for ni = 1:blocklen:bEnd
    temp = Data(ni:ni+p1-1);
    NewData(ni+p2:ni+blocklen-1) = temp;
    temp = Data(ni+p1:ni+blocklen-1);
    NewData(ni:ni+p2-1) = temp;
end

if even == 0
    ni = length(Data) - bExtra + 1
    blocklen = bExtra
    p1 = floor(blocklen/2);
    p2 = blocklen - p1;
    temp = Data(ni:ni+p1-1);
    NewData(ni+p2:ni+blocklen-1) = temp;
    temp = Data(ni+p1:ni+blocklen-1);
    NewData(ni:ni+p2-1) = temp;
end
return