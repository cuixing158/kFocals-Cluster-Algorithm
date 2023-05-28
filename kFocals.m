function [indexs,centroids,loss] = kFocals(X,k,preserve,maxIters)
% 功能：kFocals聚类算法，使得每个样本点到其簇类中心点的最大欧式距离之和（即k个最大距离之和）达到最小，而非平均距离
% 算法适用场合：距离越"偏"的点越有可能单独聚为一类，越集中分布的点聚类权重较低，对总体聚类质量影响越小，算法对集中的样本点数量无关系。
%
% 输入：X， m*2大小，[x,y]形式
%       k, 指定的簇类数量，正整数
% preserve, bool类型，为true时候，聚类中心medoids来自于X中的数据，否则是经过计算的“中心点”
%   maxIters, 1*1大小，最大迭代次数
%
% 输出：
%     indexs， 1-based索引，每个对应X每行的归属类别
%     centroids， k*2大小，[x,y]形式，簇类中心坐标
%     loss,  1*1大小，损失值
% cuixingxing150@gmail.com
% 2021.1.26
%
arguments
    X (:,2) {double}
    k (1,1) {mustBePositive,mustBeInteger}
    preserve (1,1) {logical} =true % 在原始X中取值
    maxIters (1,1) {mustBePositive,mustBeInteger} = 100
end
nums = size(X,1);
assert(nums>=k);

%% init,kmeans++
centers = zeros(k,2);% [x,y]
idx = randi(nums,1);
centers(1,:) = X(idx,:);
for i = 2:k
    currentCenters = centers(1:i-1,:);
    distancesMatrix = calPts(X,currentCenters);
    distances = min(distancesMatrix,[],2);
    selectIdx = randsample(nums,1,true,distances);
    centers(i,:) = X(selectIdx,:);
end

%% 自定义聚类算法
useIterMethod = false;
if useIterMethod  % 迭代优化,此法非kmeans,不能保证全局收敛，极易陷入局部解
    exitFlag = false; % 收敛标志
    lossLists = [];
    iterTimes = 1;
    while((iterTimes<=maxIters)&& ~exitFlag)
        distancesMatrix = calPts(X,centers);
        [~,labels] = min(distancesMatrix,[],2);
        
        cost = zeros(k,1);
        for i = 1:k
            X_cluster = X(labels==i,:);
            [centers(i,:),cost(i)] = getCenter(X_cluster,preserve);
        end
        lossLists = [lossLists;sum(cost)];
        if length(lossLists)>=2
            exitFlag = lossLists(end-1)==lossLists(end);
        end
        fprintf('iter time:%d,loss:%.10f\n',iterTimes,lossLists(end));
        disp(cost);
        iterTimes = iterTimes+1;
    end
    
    distancesMatrix = calPts(X,centers);
    [~,indexs] = min(distancesMatrix,[],2);
    centroids = centers;
    loss = lossLists(end);
else
%     fminsearch,fminunc求解器均失效，全局求解器particleswarm偶尔也会求解失效，最好加上作用区间较好
%     x0 = centers;
%     [bestx,fval,exitflag] = fminsearch(@(x)sumMaxDistance(x,X,k,preserve),x0);%
    [bestx,fval,exitflag] = particleswarm(@(x)sumMaxDistance(x,X,k,preserve),2*k);
    fprintf('优化求解质量flag:%d\n',exitflag);
  
    [~,centroids] = sumMaxDistance(bestx,X,k,preserve);
    centroids = reshape(centroids,[],2);
    distancesMatrix = calPts(X,centroids);
    [~,indexs] = min(distancesMatrix,[],2);
    loss = fval;
end
