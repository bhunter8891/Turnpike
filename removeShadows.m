function [ nosh ] = removeShadows( gr,gg,gb,x,y )
% Removes shadows from an image as detected by the shadow
% detect method. It does so using a localized dilation
% on the boundary points of the shadow, then removes
% the boundary points and repeats on the now smaller
% shadow. Note that this function works best on images
% where the shadow only covers part of the road.
%
% @inputs:
%       gr, gg, gb - separated r,g,b components of image
%       x,y - the x,y coordinates of the initial shadow
% @outputs:
%       nosh - rgb image with shadows removed

% embed gr, gg, and gb into larger matrices with borders
% of 2 pixels all around
blank = uint8(zeros(length(gr(:,1))+4,length(gr(1,:))+4));
[n, m] = size(gr);
for i = 1:n
    for j = 1:m
        blank(i+2,j+2) = gr(i,j);
    end
end
gr = blank;
blank = uint8(zeros(length(gr(:,1))+4,length(gr(1,:))+4));
for i = 1:n
    for j = 1:m
        blank(i+2,j+2) = gg(i,j);
    end
end
gg = blank;
blank = uint8(zeros(length(gr(:,1))+4,length(gr(1,:))+4));
for i = 1:n
    for j = 1:m
        blank(i+2,j+2) = gb(i,j);
    end
end
gb = blank;
blank = uint8(zeros(length(gr(:,1))+4,length(gr(1,:))+4));

% set blank to a bw image with only the shadows
% this will be used to keep track of how much of
% the shadow has been removed
for i = 1:length(x)
    blank(x(i)+2,y(i)+2) = 1;
end
blank = imfill(blank,'holes');

% set x and y to the boundary pieces
B = bwboundaries(blank);
xnew = []; ynew = [];
for j = 1:length(B)
    C = B{j};
    xnew = [xnew C(:,1)'];
    ynew = [ynew C(:,2)'];
end
x = xnew; y = ynew;

% as long as there is still shadow left
while ~isempty(x)

% dilate over points within 2 up/down/left/right
for i = 1:length(x)
   arrgr = [gr(x(i)-2,y(i)),gr(x(i)-1,y(i)),...
                       gr(x(i)+2,y(i)),gr(x(i)+1,y(i)),...
                       gr(x(i),y(i)-2),gr(x(i),y(i)-1),...
                       gr(x(i),y(i)+2),gr(x(i),y(i)+1),...
                       gr(x(i),y(i)) ];
   arrgg = [gg(x(i)-2,y(i)),gg(x(i)-1,y(i)),...
                       gg(x(i)+2,y(i)),gg(x(i)+1,y(i)),...
                       gg(x(i),y(i)-2),gg(x(i),y(i)-1),...
                       gg(x(i),y(i)+2),gg(x(i),y(i)+1),...
                       gg(x(i),y(i)) ];
   arrgb = [gb(x(i)-2,y(i)),gb(x(i)-1,y(i)),...
                       gb(x(i)+2,y(i)),gb(x(i)+1,y(i)),...
                       gb(x(i),y(i)-2),gb(x(i),y(i)-1),...
                       gb(x(i),y(i)+2),gb(x(i),y(i)+1),...
                       gb(x(i),y(i)) ];
   gr(x(i),y(i)) = max(arrgr);
   gg(x(i),y(i)) = max(arrgg);
   gb(x(i),y(i)) = max(arrgb);
end

% remove the boundary points from the shadow tracker
for i = 1:length(x)
    blank(x(i),y(i)) = 0;
end

% reset x and y to the new boundary pieces
B = bwboundaries(blank);
xnew = []; ynew = [];
for j = 1:length(B)
    C = B{j};
    xnew = [xnew C(:,1)'];
    ynew = [ynew C(:,2)'];
end
x = xnew; y = ynew;


end

% merge the components of the new images to get an rgb image
nosh(:,:,1) = gr(3:3+n-1,3:3+m-1);
nosh(:,:,2) = gg(3:3+n-1,3:3+m-1);
nosh(:,:,3) = gb(3:3+n-1,3:3+m-1);

end

