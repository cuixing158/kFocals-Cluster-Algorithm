function [pt,cost] = getCenter(X,preserve)
% 功能：对一个簇类的所有点集X找到其"中心点"medoids
% 输入：
%     X，       n*2大小，[x,y]形式坐标
%   preserve,   bool类型，为true时候，聚类中心medoids来自于X中的数据，否则是经过计算的
% 输出：
%     pt,       1*2大小，[x,y]形式坐标，代表medoid
%    cost,      1*1大小，损失值
% cuixingxing150@gmail.com
% 2021.1.27
%
arguments
    X (:,2) {double} 
    preserve (1,1) {logical} =true % 在原始X中取值
end
nums = size(X,1);

if preserve % 可穷举法求解，复杂度O(n*n))
    maxDistancesAndPts = zeros(nums,3); % [maxDist,x,y]
    for i = 1:nums
        maxDistancesAndPts(i,1) = max(calPts(X,X(i,:)));
        maxDistancesAndPts(i,2:end) = X(i,:);
    end
    [cost,idx] = min(maxDistancesAndPts(:,1));
    pt = maxDistancesAndPts(idx,2:end);
else
    L = @(x)maxDistance(x,X);
    x0 = X(1,:);
    [x,fval] = fminsearch(L,x0);
    pt = x;
    cost = fval;
end