function [ Comps ] = rgbSeg( imageFile )
% Segmentation method which splits up an image by
% color using k-means. Currently, k is hard-coded as
% 5, but this could be changed depending on the complexity of 
% the picture - i.e. one with lots of colors could have
% more clusters. Additionally, running the function over
% a range of k values and appending the components lists
% may yield a more general method.
%
% @input:
%       imageFile - image file to be segmented
% @output:
%       Comps - list of components which are candidates for roads

%Read in image, get size
J = imread(imageFile);
[x,y] = size(J(:,:,1));

%Use k-means with k=5 to segment the image
form = makecform('srgb2lab');
apform = applycform(J,form);
apd = double(apform(:,:,2:3));
nrows = size(apd,1);
ncols = size(apd,2);
apd = reshape(apd,nrows*ncols,2);
nColors = 5;
[cluster_idx, cluster_center] = kmeans(apd,nColors);
pixel_labels = reshape(cluster_idx,nrows,ncols);

%initialize an empty component list
CC = bwconncomp(zeros(x,y));

for i = 1:nColors
    %Get an empty image
    temp = zeros(x,y);
    %Set the ith component to 1 (white)
    temp(pixel_labels == i) = 1;
    %Remove any small pieces
    temp = bwareaopen(temp, floor(x*y/500));
    %Add components to master list
    CCloop = bwconncomp(temp);
    CC.PixelIdxList = [CC.PixelIdxList CCloop.PixelIdxList];
    CC.NumObjects = CCloop.NumObjects + CC.NumObjects;
end
%Code for displaying image
%labeled = labelmatrix(CC);
%RGB_label = label2rgb(labeled, 'jet', 'w', 'shuffle');
%imshow(RGB_label)

Comps = CC;

end
