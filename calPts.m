function distanceMatrix = calPts(pts1,pts2)
% 功能：计算点集pts1,pts2两两之间的距离
% 输入：
%      pts1,   m*2, [x,y]形式
%      pts2,    n*2,[x,y]形式
% 输出：
%     distanceMatrix,  m*n大小，第i行第j列的值表示第pts1中的第i个点与pts2中第j个点的距离
% cuixingxing150@gmail.com
% 2021.1.27
%
arguments
    pts1 (:,2) {double}
    pts2 (:,2) {double}
end
m = size(pts1,1);
n = size(pts2,1);
distanceMatrix = zeros(m,n);
for i = 1:m
    for j = 1:n
        distanceMatrix(i,j) = sqrt(sum((pts1(i,:)-pts2(j,:)).^2,2));
    end
end
end