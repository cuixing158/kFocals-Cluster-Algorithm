function [isGet,BW,maskedImage] = segmentTennisImage(RGB)
% Adjust data to span data range.
% RGB = imadjust(RGB);
[H,W,~] =size(RGB);
ROI = [W/2-110,H/2-75,220,150]; % 以中心区域[220,150]范围的像素为球场区域

% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Auto clustering
s = rng;
rng('default');
t_s1 = tic;
L = imSegmentKmeans(single(X),2); 
t2 = toc(t_s1);
t_s2 = tic;
L2 = imsegkmeans(single(X),2);
t3 = toc(t_s2);
fprintf('imSegmentKmeans time:%.3f second,imsegkmeans time:%.3f second',t2,t3);
figure;imshowpair(L,L2,'montage')
rng(s);
ROIImg = imcrop(L,ROI);
BW = L == round(mean(ROIImg(:)));

% Open mask with disk
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition); 
BW_t = imclose(BW, se); % 先膨胀后腐蚀,填充网球场标志线
se2 = strel('rectangle',[2,20]);
BW_t = imerode(BW_t,se2);

% Clear borders
BW_t = imclearborder(BW_t);

CC = bwconncomp(BW_t,4);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
fprintf('%.2f\n',biggest/numel(BW_t));
if (biggest>0.10*numel(BW_t)) &&(biggest<0.5*numel(BW_t))
    isGet = true;
else
    isGet = false;
end

mask = zeros(size(BW),'like',BW);
mask(CC.PixelIdxList{idx}) = 1;
BW = imfill(mask,'hole');
% se3 = strel('rectangle',[5,3]);
BW = imopen(BW,se); % 消除毛刺
se4 = strel('rectangle',[2,30]);
BW = imclose(BW,se4);% 再次填充近处标志线
BW = imfill(BW,'hole');
% BW = bwconvhull(BW);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

