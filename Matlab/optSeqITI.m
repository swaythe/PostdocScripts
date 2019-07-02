% cd('/home/sshankar/optSeq/Training')
% cd('/home/sshankar/AAT/optseq')
cd('/home/sshankar/AAT/Practice')

d = dir('trSeq-*.par');
nTr = 10;
nSave = 20;
sMat = cell(nSave,1);
durns = zeros(nTr,nSave);

for i = 1:nSave
    sMat{i} = textscan(fopen(d(i).name), '%f %f %f %f %s');
    dur = sMat{i}{3};
    didx = 2:2:nTr*2;
    durns(:,i) = dur(didx);
end

ds = reshape(durns, nSave*nTr,1);
hist(ds)