function prob_road = is_road( comp_list )
% Checks which components are roads
% Takes as input a list of components, formatted as a list of 2*n matrices
% depicting the positions of the pixels in each component
% returns the probability that each component is a road, based on its
% shape, formatted as a vector such that prob_road(i) is the probability
% that component i is a road.

%number of components
n = comp_list.NumObjects();
%list of components
comp = cell(1,n); 

%first, convert the components to a list of pixel coordinate matrices,
for i = 1:n
    [x,y] = ind2sub(comp_list.ImageSize(1:2),cell2mat(comp_list.PixelIdxList(i)));
    %[x,y] is now the list of pixel coordinates.
   comp{i} = [x,y];
end

%first, estimate the diameter of each group
%vector of estimated squares of diameters
diams = zeros(1,n);
for i = 1:n
    diams(i) = avg_diam(comp{i});
end

%allocate memory for the outside vector
map_size = 0;
for i = 1:n
    map_size = map_size + size(comp{i},1);
end
outside = zeros(2,map_size);

%array of average squares of distances to outside
out_dists = zeros(1,n);
%now, calculate the average distance from the outside array:
for i = 1:n
    outside = [];
    for j = 1:n
       if j~=i
          outside = [outside;comp{j}]; 
       end
    end
    C=1000;%number of points chosen
    d=0; %distance to point
    for k = 1:C
       pt = datasample(comp{i},1); 
       if size(pt,1)==1&&size(pt,2)==2
           d = d+group_dist(pt,outside);
       end
    end 
    out_dists(i)=d/C; 
end
    %this is currently set to the narrowness ratio. Needs to be set to a
    %function of the narrowness ratio that uses it to get probability of
    %being a road, using (manual) labled machine learning.
    prob_road=out_dists./(diams);
    
    %calculate the centres' coordinates, and show them
    s = regionprops(comp_list,'centroid');
    centroids = cat(1, s.Centroid);
    colors = 'bgrky';
    symbols = '+o*xs^v><p';
    for i = 1:n
        hold on
        symb = 'y<';
        if i<length(colors)*length(symbols)
            symb(1) = colors(floor((i-1)/length(symbols))+1);
            symb(2) = symbols(mod(i-1,length(symbols))+1);
        end
        plot(centroids(i,1),centroids(i,2), symb)
        hold off
    end
    diams
    %out_dists
    %out_dists./(diams)
    %for i = 1:n
    %    prob_road(i)=prob_calc(prob_road(i));
    %end
end

function d = group_dist(point,group)
%calculates the square of the minimum distance of a point from a group
%assumes point is a single 1*2 vector, and group is an n*2 matrix listing
%n two-dimensional points.

n2 = size(group,1);
v = ones(n2,1)*point;
u = group-v;
w = u(:,1).*u(:,1)+u(:,2).*u(:,2);
d = min(w);
end

function p = prob_calc(x)
%this function calculates the probability of a component with width
%variable x being a road.
%uses means and variances m1 s1 m2 s2, where 2 is the case for is road,
%learned from examples.
m1 = 8.7527;
s1 = 256.9875;
m2 = 0.0246;
s2 = 9.0989e-04;
a1 = ((x-m1)^2)/(2*(s1));
a2 = ((x-m2)^2)/(2*(s2));
p = (s2/s1)^0.5*(exp(a2-a1));
p = 1/(1+p);
end


function d = avg_diam(pix_set)
%given a 2*n vector, returns the square of the average diameter of the group as a set
%of n points in a plane by choosing C=1000 random pairs and averaging 
% the distances between them
C=1000;
u = datasample(pix_set,C)-datasample(pix_set,C);
v = u(:,1).*u(:,1)+u(:,2).*u(:,2);
d = mean(v);
end

%further factors that may be useful to add, but would need labled examples
%to work well:
% extent, distance of centroid to edge, eccentricity,solidity. These can be
% calculated using regionprops.
% others (which can't): moments of the distribution of the distance between
% pairs of points.

%idea 2: try to tell shape of road from fractal
