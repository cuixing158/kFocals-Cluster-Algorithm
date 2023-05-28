imds = imageDatastore('E:\HiKangPlayerObjectDetectDataBase\train',...
    'FileExtensions','.jpg');
imds = shuffle(imds);


for i = 1:20
    RGB = readimage(imds,i);
%     RGB = imread('10.131.13.213_监控点1_10.131.13.213_20210120170146_670575.jpg');
    [isGet,BW,maskedImage] = segmentTennisImage(RGB);
  
    B = bwboundaries(BW,8,'noholes');
    B = B{1};
%     avbB = mean(B);
%     objB = B -avbB;
%     [theta, rho] = cart2pol(objB(:,2), objB(:,1));

    %# find corners
    tolerance = 0.015;
    p_reduced = reducepoly(B,tolerance);
    

    outImg = labeloverlay(RGB,BW);
    
   figure;imshow(outImg);hold on
   line(p_reduced(:,2),p_reduced(:,1), ...
       'color','r','linestyle','-','linewidth',1.5,...
       'marker','o','markersize',5);
   %    plot(avbB(1,2),avbB(1,1),'r*')
   %    plot(B(corners,2),B(corners,1),'s', 'MarkerSize',10, 'MarkerFaceColor','r')
   hold off;
   
   %% 校正变换
%    RGB = imresize(RGB,[270,480]);
%    imshow(RGB)
%    [x,y] = ginput(4); %右下,左下，右上，左上
%    movingPoints = [x,y];
%    %    fixedPoints = [-5.48,11.885;5.48,11.885;-5.48,-11.885;5.48,-11.885];
%    [x_f,y_f] = ginput(4); %右下,左下，右上，左上
%    fixedPoints = [x_f,y_f];
%    tform = fitgeotrans(movingPoints,fixedPoints,'projective');
%    Jregistered = imwarp(RGB,tform);
%    figure
%    imshow(Jregistered)
end

