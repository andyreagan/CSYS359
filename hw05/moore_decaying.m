function [indices,coeff] = moore_decaying(iter,i,C)
% return the indices and the coefficients of the nbd of node i
%
% INPUT
%
% iter: iteration of the training
% i: index of the node
% C: adjacency matrix
%
% OUTPUT
% indices: indices of the neighbors
% coeffs: update coeffs of the neighbors

% convert the iteration to a path length
% ilen = 0.9*(1-iter/1000);
plen = max(1,floor(floor(length(C(1,:))/4)-iter*floor(length(C(1,:))/4)/10));

% display(plen);

indices = find(C(:,i)==1);
for j=2:plen
    l = length(indices);
    for k=1:l
        if ~isempty(find(C(:,indices(k))==1, 1))
            % disp(find(C(:,indices(k))==1));
            indices = [indices;find(C(:,indices(k))==1)];
        end
    end
end

indices = unique(indices);

% don't scale them...
coeff = ones(size(indices));

end