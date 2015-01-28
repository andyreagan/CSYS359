% simple feed-forward backpropogation implementation
% in MATLAB here
%
% data is in the adjacent folder data
% in files named
% input.csv
% target.csv
%
% in the main part of the algorithm, I do it in many steps
% just for clarity
% it could be written in like 3 lines
%
% 2015-01-27
% Andy Reagan

% read in data
I = csvread('data/inputs.csv');
T = csvread('data/target.csv');

% number of internal (hidden) nodes to use
N = 4;

% initialize weights in [-1,1]
% indexed like (input node (layer 1), output node (layer 2))
W = rand(length(T(1,:)),N)*2-1;
V = rand(N,length(I(1,:)))*2-1;
% hm, reverse these so that I can multiply with them on the left
W = W';
V = V';

% internal node values
K = zeros(N,1);

% number of timesteps to train for
trainingTime = 500;
errors = zeros(1,trainingTime);

eta = 2;

% define sigmoid derivative
sigmfd = @(x) exp(x)./((1+exp(x)).^2);

% loop over training time
for i=1:trainingTime
    % loop over the datasets
    % could do this without a loop, but until I get it working...
    % (everything would p-dimensional matrices instead of vectors)
    for j=1:length(I(:,1))
        %%  propogate forward
        % compute hidden node sum
        K = W*I(j,:)';
        % apply sigmoid activation function
        M = sigmf(K,[1,0]);
        % prediction sum from network
        J = V*M;
        % final prediction
        K = sigmf(J,[1,0]);
        % of course
        % P = sigmf(V*sigmf(W*I(j,:),[1,0]),[1,0]);
        % error at each output node
        E = K-T(j,:)';
        % compute the delta at the hidden nodes
        % transpose of V goes back
        d = E.*sigmfd(J);
        % now compute delta at the input nodes
        dw = V'*d.*sigmfd(K);
        % new weights, proportional to the gradient of cost function
        W = W - eta*dw*I(j,:);
        V = V - eta*d*K';
    end
    % compute total error at this timestep
    for j=1:length(I(:,1))
        errors(i) = errors(i) + sum((T(j,:)'-sigmf(V*sigmf(W*I(j,:)',[1,0]),[1,0])).^2);
    end
    errors(i) = sqrt(errors(i)/length(I(:,1))/length(T(1,:)));
end

plot(1:trainingTime,errors)
xlabel('timestep')
ylabel('error')

% final predictions
predictions = zeros(length(I(:,1)),4);
for j=1:length(I(:,1))
    predictions(j,:) = sigmf(V*sigmf(W*I(j,:)',[1,0]),[1,0]);
end

% now try to interpolate
a = [.5,.2,.4,.5];
predictions(4,:) = sigmf(V*sigmf(W*a',[1,0]),[1,0]);

csvwrite('data/interpolation.csv',predictions);



