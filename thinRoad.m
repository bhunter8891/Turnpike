function [ Comps ] = thinRoad( imageFile )
% Segmentation method with adjustments to accomodate
% narrow roads better.
% @input:
%       imageFile - image file to be segmented
% @output:
%       Comps - list of components which are candidates for roads


% Read in file, convert to gray, get size
J = imread(imageFile);
I = rgb2gray(J);
I2 = imcomplement(I);
[x,y] = size(I);

%Split up image by intensity
BW1 = I > 150;
BW2 = I2 > 150;
%Remove any small pieces, but only very small to avoid
%removing any pieces of the road
BW1 = bwareaopen(imfill(BW1,'holes'),floor(x*y/1000));
BW2 = bwareaopen(imfill(BW2,'holes'),floor(x*y/1000));
%Get component lists and merge
CC1 = bwconncomp(BW1);
CC2 = bwconncomp(BW2);
CC1.PixelIdxList = [CC1.PixelIdxList CC2.PixelIdxList];
CC1.NumObjects = CC1.NumObjects + CC2.NumObjects;

%Code for displaying image
%labeled = labelmatrix(CC1);
%RGB_label = label2rgb(labeled, 'jet', 'w', 'shuffle');
%imshow(RGB_label)

Comps = CC1;

end

