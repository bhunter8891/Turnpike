function [ Comps ] = simpleSegmentation( imageFile )
% This method enhances external boundaries, darkens internal boundaries, 
% and uses Canny edge detection to split the image up into components.
% 
% @inputs:
%       imageFile - image to be segmented
% @outputs:
%       Comps - list of components which are road candidates

% Read file, keep original and gaussian blurred.
% rgb = imread(imagefile);
rgb=imageFile;
rgbblur = imgaussfilt(rgb,1.1);

%%%% 'I' builds the edges to seperate intersecting roads.

%  flipped grayscale
I = rgb2gray(rgbblur);
I = imcomplement(I);

%  find edges (white) with Canny and thicken, parameters adjusted empirically.
I = edge(I, 'Canny', [0.1, 0.3]);
I = bwmorph(I, 'thicken', 1.1);

%  fattens edges and connectes small gaps by dilating and coroding using
%  squares for structure element (5x5 pixels), then shrinks the edges back to
%  lines. Complement to make edges black (value zero).
se = strel('square', 5);   %25
I = imclose(I, se);
I = bwmorph(I, 'shrink', Inf);
I = imcomplement(I);

% J is going to segment regions into road-like objects and value -> 0 for
% things that aren't 

J = zeros(size(rgb(:,:,1)));
ss = size(J); 
for i = 1:ss(1)
    for j = 1:ss(2)
        J(i,j) = blackedOut(rgbblur(i,j,1), rgbblur(i,j,2),rgbblur(i,j,3));
    end
end

% H is componentwise multiplication, zeros out edges from I!

H = I .* J;

% LB = 3000;
% UB = 160000;
% Hfilt = xor(bwareaopen(H,LB),  bwareaopen(H,UB));

Hfilt = bwareaopen(H,800, 4);

ccFilt= bwconncomp(Hfilt, 4);
labelFilt = labelmatrix(ccFilt);
roadsFilt = label2rgb(labelFilt, 'lines', 'w', 'shuffle');

%figure
%imshowpair(rgb,roadsFilt, 'montage')

Comps = ccFilt;

% CCH = bwconncomp(H, 4);
% labeledH = labelmatrix(CCH);
% roadsH = label2rgb(labeledH, 'jet', 'w', 'shuffle');

%Comps1 = CCH

%s = regionprops(CCH,'basic')
end


% Helper function which sets background pieces to 0 (black)
% in an image. Takes in 3 values which are the r,g,b components
% of a pixel, and returns 0 or 1 to denote if the pixel should
% be considered road or not.
function z = blackedOut(a,b,c)
if max([abs(a-b), abs(b-c), abs(c-a)])>30  %17
    z = 0;
elseif max([a,b,c])<120  %68
    z = 0;
elseif min([a,b,c])>245 %110 %235  %170
    z = 0;
else
    z = 1;
end
end


    