% clear all
% close all

% load the data, into the variable X
load AnimalData.mat
A = X';

% % make the interpolation data set
% % looks like the x and y in the training data
% % go close to 200 and 250, respectively
% % so interpolation at every point up to those
% [X,Y] = meshgrid(0:.01:1,0:01:1);
% interpolation = [X(:),Y(:)];

% normalize the data to the unit sphere
% [training_norm,interpolation_norm] = nomalize_input_andy(training(:,1:end-1),interpolation);

numiter = 150;
randorder = 1;

% initialize the kohonen weights
% these are the m_i
num_nodes = 49;
B = rand(length(A(:,1)),num_nodes);

node_network_size = [7,7]; % down x across

% create the adjacency matrix
C = zeros(num_nodes,num_nodes);
for i=1:node_network_size(1) % down
    for j=1:node_network_size(2) % across
        indices = unique([sub2ind(node_network_size,i,min([node_network_size(2),j+1])),sub2ind(node_network_size,i,max([1,j-1])),sub2ind(node_network_size,max([1,i-1]),j),sub2ind(node_network_size,min([i+1,node_network_size(1)]),j)]);
        % disp(indices);
        C(sub2ind(node_network_size,i,j),indices) = 1;
        C(indices,sub2ind(node_network_size,i,j)) = 1;
        C(sub2ind(node_network_size,i,j),sub2ind(node_network_size,i,j)) =1;
    end
end

% train the weight matrices
[B,errors_all] = train_SOM(A,B,C,numiter,randorder,@scaling_inverse,@moore_decaying,0);

figure(111)
titles = {'dove','hen','duck','goose','owl','hawk','eagle','fox','dog','wolf','cat','tiger','lion','horse','zebra','cow'};
for i=1:length(A(1,:))
    min_dist = sqrt(sum((A(:,i)-B(:,1)).^2));
    winning_node = 1;
    for k=2:num_nodes
        dist = sqrt(sum((A(:,i)-B(:,k)).^2));
        if dist<min_dist
            min_dist = dist;
            winning_node = k;
        end
    end
    fprintf('winning node is %f\n',winning_node);
    [nodei,nodej] = ind2sub(node_network_size,winning_node);
    text(nodei,nodej,sprintf('%s',titles{i}))
    hold on;
end
xlim([0.5 node_network_size(1)+.5])
ylim([0.5 node_network_size(2)+.5])

% plot(1:numiter,mean(errors_all,1))
% title('convergence of SOM')
% xlabel('iteration')
% ylabel('avg distance to training data')
% saveas(111,'figures/convergence of SOM.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here let's do the uniform distribution in 2D
% reproducing figure 3 of kohonen
numsamples = 1000;
A = rand(2,numsamples);

numiter = 10;
randorder = 1;

% initialize the kohonen weights
% these are the m_i
num_nodes = 100;
B = rand(length(A(:,1)),num_nodes);

node_network_size = [10,10]; % down x across

% create the adjacency matrix
C = zeros(num_nodes,num_nodes);
for i=1:node_network_size(1) % down
    for j=1:node_network_size(2) % across
        indices = unique([sub2ind(node_network_size,i,min([node_network_size(2),j+1])),sub2ind(node_network_size,i,max([1,j-1])),sub2ind(node_network_size,max([1,i-1]),j),sub2ind(node_network_size,min([i+1,node_network_size(1)]),j)]);
        % disp(indices);
        C(sub2ind(node_network_size,i,j),indices) = 1;
        C(indices,sub2ind(node_network_size,i,j)) = 1;
        C(sub2ind(node_network_size,i,j),sub2ind(node_network_size,i,j)) =1;
    end
end

iterations = [0,20,100,1000,5000,10000];
iterations = [0,10,20,30,40,50];

figure(112);

i=1;
subplot(2,3,i);
plot(B(1,:),B(2,:),'s');
title(sprintf('%.0f iterations',iterations(i)))

% % train the weight matrices
% for i=2:length(iterations)
%     [B,errors_all] = train_SOM(A,B,C,iterations(i)-iterations(i-1),randorder,@scaling_inverse,@moore_decaying,iterations(i-1));
%     subplot(2,3,i);
%     plot(B(1,:),B(2,:),'s');
%     title(sprintf('%f iterations',iterations(i)))
% end