function L = maxDistance(x,X)
% 功能：单个簇类的损失函数(最大距离),而非距离的平方和
% 输入：
%    x  ,1*2大小，[x,y]形式，待优化的变量x,
%    X，  已知的数据X，n*2大小，[x,y]形式
% 输出：
%     L， 1*1大小，损失值
% cuixingxing150@gmail.com
% 2021.1.27
%
nums = size(X,1);
Loss = zeros(nums,1);

for i = 1:nums
    Loss(i,1) =sqrt((x(1)-X(i,1)).^2+(x(2)-X(i,2)).^2);
end
L = max(Loss);


