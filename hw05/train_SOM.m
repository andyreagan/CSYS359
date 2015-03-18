function [B,rmse_all] = train_SOM(A,B,C,numiter,randorder,scaling_fun,nbd_fun,iterstart)
% train the SOM neural net
%
% INPUTS
%
% A(size input,num training patterns)
% the training patterns
%
% B(size input,num nodes in kohonen)
% the m_i states of the nodes
%
% C(num nodes,num nodes)
% adjacency matrix for the nodes
%
% OUTPUT
%
% B: kohenen matrix values

% how long to train
% numiter = 50;
% taking this from input

num_training_patterns = length(A(1,:));
num_nodes = length(B(1,:));

% rmse_all = ones(num_training_patterns+(1-traintogether)* ...
%                 num_training_patterns,numiter);
rmse_all = ones(num_training_patterns,numiter);

fprintf('training\n');
for i=1+iterstart:numiter+iterstart
    fprintf('on training iteration no %f\n',i);
    if randorder
        order = 1:num_training_patterns;
    else
        order = randperm(num_training_patterns);
    end
    scaling_coeff = scaling_fun(i);
    fprintf('scaling coeff is %f\n',scaling_coeff);
    for j=order
        % find the index of the winner
        min_dist = sqrt(sum((A(:,j)-B(:,1)).^2));
        winning_node = 1;
        for k=2:num_nodes
            dist = sqrt(sum((A(:,j)-B(:,k)).^2));
            if dist<min_dist
                min_dist = dist;
                winning_node = k;
            end
        end
        % fprintf('winning node is %f\n',winning_node);
        rmse_all(j,i-iterstart) = min_dist;
        [nbd,nbd_coeffs] = nbd_fun(i,winning_node,C);
        % fprintf('tuning the nbd of size %f\n',length(nbd))
        for k=1:length(nbd)
            B(:,nbd(k)) = B(:,nbd(k)) - scaling_coeff*nbd_coeffs(k)*(B(:,nbd(k))-A(:,j));
        end
    end
    % rmse_avg(1,i) = mean(rmse_all(:,i));
end

end