function [ Comps ] = blurSegmentation( imageFile )
% Segmentation method that works by blurring the image
% using erosion, dilation, and reconstruction to make
% it more even in color distribution, then looks for
% maximums to get components.
% Looks at both the image and it's complement to avoid
% not finding the road in the event that it's a local min.
%
% @input:
%       imageFile - image file to be segmented
% @output:
%       Comps - list of components which are candidates for roads

% Read in image, convert to grayscale
J = imread(imageFile);
I = rgb2gray(J);
I = imcomplement(I);

% Create structural element and use it to smooth out image
se = strel('square', 20);
Io = imopen(I, se);
Ie = imerode(Io, se);
Iobr = imreconstruct(Ie, I);
Iobrd = imdilate(Iobr, se);
blur1 = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
blur2 = imcomplement(blur1);

% Get maximums and fill in any holes
fgm = imregionalmax(blur1);
fgm2 = imregionalmax(blur2);
fgm = imfill(fgm,'holes');
fgm2 = imfill(fgm2,'holes');
%Get component lists and merge
CC1 = bwconncomp(fgm);
CC2 = bwconncomp(fgm2);
CC1.PixelIdxList = [CC1.PixelIdxList CC2.PixelIdxList];
CC1.NumObjects = CC2.NumObjects + CC1.NumObjects;


% Code for showing components alongside image
%labeled = labelmatrix(CC1);
%RGB_label = label2rgb(labeled, 'jet', 'w', 'shuffle');
%imshow(RGB_label)

Comps = CC1;

end

