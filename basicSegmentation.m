function [ Comps ] = basicSegmentation( imageFile )
% Basic segmentation method which does not sharpen or
% blur image significantly. It finds the edges, dilates, and removes
% small components.
%
% @input:
%       imageFile - image file to be segmented
% @output:
%       Comps - list of components which are candidates for roads

% Read in file, convert to grayscale
J = imread(imageFile);
I = rgb2gray(J);
I = imcomplement(I);
[x,y] = size(I);

% Get edges, and thicken
BW = edge(I,'Canny');
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BW, [se90 se0]);
blank = ~BWsdil;

% remove any small pieces
blank = bwareaopen(imfill(blank,'holes'),floor(x*y/100));
BWsdil = bwareaopen(imfill(BWsdil,'holes'),floor(x*y/100));

% get components
CC1 = bwconncomp(blank);
CC2 = bwconncomp(BWsdil);
CC1.PixelIdxList = [CC1.PixelIdxList CC2.PixelIdxList];
CC1.NumObjects = CC1.NumObjects + CC2.NumObjects;

% Code for displaying components alongside original image
labeledThin = labelmatrix(CC1);
RGB_labelThin = label2rgb(labeledThin, 'jet', 'w', 'shuffle');
imshowpair(J,RGB_labelThin, 'montage')

Comps = CC1;

end

