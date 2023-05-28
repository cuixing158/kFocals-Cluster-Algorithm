function [L,x] = sumMaxDistance(x,X,k,preserve)
% 功能：单个簇类的损失函数(最大距离),而非距离的平方和
% 输入：
%    x  ,1*2大小，[x1,y1;x2,y2;...;xk,yk]形式，待优化的簇类中心变量x,
%    X，  已知的数据X，n*2大小，[x,y]形式
%    k, 簇类数量
% preserve, bool类型，为true时候，聚类中心medoids来自于X中的数据，否则是经过计算的
% 输出：
%     L， 1*1大小，损失值
%     x, 1*2大小，[x1,y1;x2,y2;...;xk,yk]形式，即覆盖输入的x
% 注意：输入的x是按“值”传递，不涉及深拷贝，故输出x覆盖
%
% cuixingxing150@gmail.com
% 2021.1.28
%
isFlag = true;
while isFlag
    isFlag = false;
    x = x(:);
    x = reshape(x,[],2);
    distancesMatrix = calPts(X,x);
    [minV,labels] = min(distancesMatrix,[],2);
    [~,idx] = max(minV);
    Xtemp = X(idx,:);
    
    cost = zeros(k,1);
    for i = 1:k
        X_cluster = X(labels==i,:);
        if isempty(X_cluster) % 少了一个聚类中心，易陷入局部最优解，一般发生在初始中心在较远处
            x(i,:) = Xtemp;
            isFlag = true; 
            continue;
        end
        [x(i,:),cost(i)] = getCenter(X_cluster,preserve);
    end
    L = sum(cost);
end
