function newimg =   showAllRoads(img,CC,X)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
labeled = labelmatrix(CC);
newimg= label2rgb(labelmatrix(CC), 'parula', 'b', 'shuffle');
[m,n] = size(labeled);
for i =1: m
    for j = 1:n
        if(labeled(i,j) ==0)
            newimg(i,j,1) = img(i,j,1);
            newimg(i,j,2) = img(i,j,2);
            newimg(i,j,3) = img(i,j,3);
        end
    end
end
newimg =selectedRoads(newimg,CC,X);


end

