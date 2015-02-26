function [W,V,rmse_all] = train_counterprop_andy(A,B,numiter,randorder,scaling_fun,traintogether,nearest_neighbor)
% train the two counterprop matrices
%
% INPUTS
%
% A(num train patterns,size input)
% B(num train patterns,size output)
%
% OUTPUT
%
% V: Kohonen layer weights
% W: Grossberg layer weights

% how long to train
% numiter = 50;
% taking this from input

% hardcode learning coeff
alpha = 0.7; % kohonen
beta = 0.2; % grossberg


num_training_patterns = length(A(:,1));

% rmse_all = ones(num_training_patterns+(1-traintogether)* ...
%                 num_training_patterns,numiter);
rmse_all = ones(num_training_patterns,numiter);
% rmse_avg = ones(1,numiter);

input_size = length(A(1,:));
output_size = length(B(1,:));

% kohonen later
if nearest_neighbor
    hidden_layer_size = num_training_patterns;
    W = A';
else
    hidden_layer_size = num_training_patterns+3;
    W = rand(input_size,hidden_layer_size);
end
% disp(size(W));
% grossberg layer
V = rand(hidden_layer_size,output_size);

if ~nearest_neighbor
    fprintf('training kohonen layer\n');
    for i=1:numiter
        % fprintf('on training iteration no:\n');
        % disp(i);
        if randorder
            order = 1:num_training_patterns;
        else
            order = randperm(num_training_patterns);
        end
        for j=order
            % apply kohonen weights to compute middle layer
            % in your paper, figure 4 shows that this should compute
            % the minumim distance between input and kohonen layer
            % weights...
            % this just applies the weights forward:
            I = A(j,:)*W;
            % and this is more akin the distance
            % (1x3)*(3x78) = (1x78)
            % I = 1-A(j,:)*W;
            % NOTE: these are the "z_j" in the psuedocode
            
            % find the index of min
            % if we didn't take 1-... in the above, could take the max:
            winning_node = find(I==max(I),1);
            % this variable is akin to "c" in the code
            % winning_node = find(I==min(I),1);
            
            % update this just to look at in debugging
            % I = I>=max(I);
            
            % disp(I);
            % disp(winning_node);
    
            % update the winning node's links in kohonen layer
            % this should move the weights toward the input
            
            % fprintf('input');
            % disp(A(j,:)');
            % fprintf('winning row');
            % disp(W(:,winning_node));
            W(:,winning_node) = W(:,winning_node) + scaling_fun(alpha,i)*(A(j,:)'-W(:,winning_node));
            % fprintf('winning row after');
            % disp(W(:,winning_node));
            
            % update links in grossberg layer
            % note that y' is just V(winning_node,:)
            % since the a_j is set to 1
            if traintogether
                % save the error in the output
                output_error = B(j,:)-V(winning_node,:);
                
                rmse_all(j,i) = rmse(B(j,:),V(winning_node,:));
                V(winning_node,:) = V(winning_node,:) + scaling_fun(beta,i)*(output_error);
            end
        end
        % rmse_avg(1,i) = mean(rmse_all(:,i));
    end
end

% train the grossberg layer
if ~traintogether || nearest_neighbor
    fprintf('training just grossberg layer now\n');
    for i=1:numiter
        if randorder
            order = 1:num_training_patterns;
        else
            order = randperm(num_training_patterns);
        end
        for j=order
            I = 1-A(j,:)*W;
            winning_node = find(I==min(I),1);
            output_error = B(j,:)-V(winning_node,:);
            rmse_all(j,i) = rmse(B(j,:),V(winning_node,:));
            V(winning_node,:) = V(winning_node,:) + scaling_fun(beta,i)*(output_error);
        end
    end 
end

end


