function [X ] = Interactivity(img,CC,X)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
labeled=labelmatrix(CC);
[m,n] = size(labeled);

num = CC.NumObjects;
[x,y] = ginput(1);
z= ceil(x);
x = ceil(y);
y=z;
a = labeled(x,y);
if(a == 0)
    msgbox('That is not a road! Try again.');
    Interactivity(img,CC,X);
elseif X(a)==0
    X(a) = 1;
    %imshow(selectedRoads(img, CC,X)); 
    %{
    for i=1:m
        for j = 1:n
            if labeled(i,j) ==a
                abc(i,j,1) = 0;
                abc(i,j,2) = 0;
                abc(i,j,3) = 255;
            end
        end
    end
    for i = -5:1:5
        for j = -5:1:5
            abc(x+i,y+j,1) = 255;
            abc(x+i,y+j,2) = 0;
            abc(x+i,y+j,3) = 0;
            abc(x+i,y,1) = 255;
            abc(x+i,y,2) = 0;
            abc(x+i,y,3) = 0;
            abc(x,y+j,1) = 255;
            abc(x,y+j,2) = 0;
            abc(x,y+j,3) = 0;
        end
    end
    %}
    
else 
    X(a) = 0;
    %imshow(selectedRoads(img, CC,X)); 
    %{
    for i=1:m
        for j = 1:n
            if labeled(x,y) ==a
                abc(x,y,1) = img(x,y,1);
                abc(x,y,2) = img(x,y,2);
                abc(x,y,3) = img(x,y,3);
            end
        end
    end
%}
end
   
%Interactivity(CC,img,abc,X);
end

