function labelMatrix = imSegmentKmeans(inImg,numClusters)
% 功能：实现官方imsegkmeans函数功能
% 输入：inImg: 2-D image
%      numClusters: 聚类数量
% 输出：
%     labelMatrix:聚类后标注矩阵，从1开始
%
% cuixingxing150@gmail.com
% 2021.1.21
%
arguments
    inImg
    numClusters (1,1) double = 2
end

% normalize Input
[h,w,c] = size(inImg);
input = zeros(size(inImg));
for i = 1:c
    currentChannel = inImg(:,:,i);
    input(:,:,i) = (currentChannel-mean(currentChannel,'all'))./std(currentChannel,1,'all');
end
allPixels = reshape(input,[],3);
idx = kmeans(allPixels,numClusters);
labelMatrix = reshape(idx,h,w);
end