%% main program
pts = [331.171  752.29
1788.12  776.438
333.575  752.33
252.87  805.105
1714.75  728.667
255.627  804.96
807.841  430.778
1245.11  422.89
809.85  430.743
253.936  804.386
1028.57  281.899
341.498  745.324
183.316  852.02
327.699  754.633
1713.66  727.961
256.694  804.242
1029.44  282.47
1856.69  821.086
1705.55  722.68
1784.67  774.189
343.78  745.439
186.31  851.765
330.115  754.666];
frame = imread('test.jpg');
k = 5;
preserve = false;% 聚类“中心”centroids是否来自样本集pts中的点
[idxs,centers,loss] = kmedoids(pts,k);
% [idxs,centers,loss] = kFocals(pts,k,preserve);

draw
figure;imshow(frame);hold on;ax = gca;
colors = rand(k,3);
maxDist = zeros(k,1);
for i = 1:k
    currentClusterPts = pts(idxs==i,:);
    currentCenter = centers(i,:);
    distMat = calPts(currentClusterPts,currentCenter);
    [maxDist(i),ind] = max(distMat);
    pt = currentClusterPts(ind,:);
    plotPts = [pt;currentCenter];
    textPt = mean(plotPts);
    
    hCen = plot(ax,currentCenter(:,1),currentCenter(:,2),'^','MarkerSize',15,'Color',colors(i,:));
    h(i) = plot(ax,currentClusterPts(:,1),currentClusterPts(:,2),'+','Color',colors(i,:));
    plot(ax,plotPts(:,1),plotPts(:,2),'-','LineWidth',1,'Color',colors(i,:));
    text(ax,textPt(1),textPt(2),"max distance:"+maxDist(i));
end
legend([h,hCen],["kmedoids cluster:"+string(1:k),"Centroids"])
title("Loss:"+sum(maxDist)+"="+join(string(maxDist),"+"));
