main_dir = '/home/sshankar/Categorization/Data/Imaging/All/ROI_MECorr_005corr_bigROI/';
cd(main_dir);

% Load betasCD from the ROI directory. It loads 3 variables:
% betas: an nSub x nROI x nCDCombo cell containing beta values
% coords: an nROI x nCoordDim x nSub cell containing ijk
%         coordinates of top voxel of each ROI, for each subject
% idxs: an nSub x nROI x nCDCombo cell containing indices from
%         collData for each subject of each CD pair in the behavior matrix
coord_file = 'betasCD'; 
load(coord_file)

cs = 'rgbkm';

for si = 1:1 %size(betas,1)
    for ri = 1:size(betas,2)
        figure
        for i = 1:4
            for j = 1:5
                subplot(2,5,i), hold on
%                 plot(betas{si,ri,(i-1)*5+1+(j-1)},'Marker','.','color',cs(j),'LineStyle','.')
%                 mb = mean(squeeze(betas{si,ri,(i-1)*5+1+(j-1),1}));
%                 line([j j+1],[mb mb],'Marker','.','color',cs(j),'LineStyle','-.')
                mb = mean(mean(squeeze(betas{si,ri,(i-1)*5+1+(j-1),2})));
                line([j j+1],[mb mb],'Marker','.','color',cs(j),'LineStyle','-')
%                 axis([0 10 1 3])
            end
        end
        for j = 1:5
            for i = 1:4
                subplot(2,5,j+5), hold on
%                 plot(betas{si,ri,(i-1)*5+1+(j-1)},'color',cs(i),'Marker','.','LineStyle','.')
%                 mb = mean(squeeze(betas{si,ri,(i-1)*5+1+(j-1),1}));
%                 line([i i+1],[mb mb],'color',cs(i),'Marker','.','LineStyle','-.')
                mb = mean(mean(squeeze(betas{si,ri,(i-1)*5+1+(j-1),2})));
                line([i i+1],[mb mb],'color',cs(i),'Marker','.','LineStyle','-')
%                 axis([0 10 0 3])
            end
        end
    end
end
