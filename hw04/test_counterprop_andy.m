function [fullgrid] = test_counterprop_andy(kohonen,grossberg,interpolation,training)
% something something something
    
% define the full grid to test    
% xmax = max(interpolation(:,1));
% ymax = max(interpolation(:,2));
% oops, those are normalized!!
xmax = 200;
ymax = 250;
fullgrid = ones(xmax,ymax);

winner_take_all = @(x) x>=(max(x));

for x=1:xmax
    for y=1:ymax
        % this is non vectorized
        % % indexing!
        % A = interpolation(x*ymax-ymax+y,:);
        % % apply kohonen layer
        % I = 1-A*kohonen;
        % % threshold
        % I = winner_take_all(I);
        % % apply grossberg layer
        % Y = I*grossberg;
        % % threshold
        % Y = winner_take_all(Y);
        % % take the number from the output!
        % fullgrid(x,y) = find(Y==max(Y));
        
        % this is vectorized
        % but redundant
        % fullgrid(x,y) = find(winner_take_all(1-interpolation(x*ymax-ymax+y,:)*kohonen)*grossberg==max(winner_take_all(1-interpolation(x*ymax-ymax+y,:)*kohonen)*grossberg));
        % better
        B = winner_take_all(1-interpolation(x*ymax-ymax+y,:)*kohonen)*grossberg;
        fullgrid(x,y) = find(B==max(B));
    end
end

% i am very aware that this is missing a row when using flat
% shading
% but I don't feel like fighting with matlab
figure(116);
pcolor(fullgrid);
shading flat;
colorbar;

end
