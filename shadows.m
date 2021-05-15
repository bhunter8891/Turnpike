function  shadows( img )
% An open source function for shadow detection with reference below. 
% We also considered different methods for shadow detection including
% analyzing pixel values in both B&W and RGB arrays. 

%% Shadow Detection Source Code
% Shared by Beril Sirmacek
% For Academic & Educational Usage Only
% Please consider citing following reference articles.
% 
% B. Sirmacek and C. Unsalan, "Damaged Building Detection in Aerial Images 
% using Shadow Information", 4th International Conference on Recent Advances 
% in Space Technologies RAST 2009, Istanbul, Turkey, June 2009.
%
% C. Unsalan and K. L. Boyer, "Linearized vegetation indices based on a formal 
% statistical framework," IEEE Transactions on Geoscience and Remote Sensing, 
% vol. 42, pp. 1575-1585, 2004. 

%%


thresh1 = 0.0;
thresh2 = 30;

im=img;
imgray=rgb2gray(img);
% NOTE: You might need different median filter size for your test image.
r = medfilt2(double(im(:,:,1)), [3,3]); 
g = medfilt2(double(im(:,:,2)), [3,3]);
b = medfilt2(double(im(:,:,3)), [3,3]);
[m,n,xxx]=size(im);
img2 = zeros(m,n,3);
img2(:,:,1) = r;
img2(:,:,2) = g;
img2(:,:,3) = b;
%figure,imshow(img2);
%% Calculate Shadow Ratio:

shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
%figure, imshow(shadow_ratio, []); colormap(jet); colorbar;

% NOTE: You might need a different threshold value for your test image.
% You can also consider using automatic threshold estimation methods.
shadow_mask = shadow_ratio>thresh1;%.2
%figure, imshow(shadow_mask, []); 

shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;

% NOTE: Depending on the shadow size that you want to consider,
% you can change the area size threshold
shadow_mask = bwareaopen(shadow_mask, thresh2);%100
[x,y] = find(imdilate(shadow_mask,strel('disk',2))-shadow_mask);

%figure, imshow(im); hold on,
hold on, p=plot(y,x,'.r');
J=regionfill(imgray,shadow_mask);
%figure, imshow(J);
%%



end

