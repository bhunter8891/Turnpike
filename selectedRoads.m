function imgSel = selectedRoads(img,CC,X)
%For the selected roads in X, we turn all of them blue in the current
%image.
labeled = labelmatrix(CC);
imgSel = img;
[m,n]=size(labeled);
% The xxx variable is not used
[xxx,a] = size(X);
for i = 1:a
    if X(i) ==1
        for j = 1:m
            for k= 1:n
                if labeled(j,k) == i
                    imgSel(j,k,1) = 0;
                    imgSel(j,k,2) = 0;
                    imgSel(j,k,3) = 255;
                end
            end
        end
    end
end


end

