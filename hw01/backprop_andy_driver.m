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
% 1 for bias, 0 for no bias
bias = 1;
% 1 for momentum, 0 for no momentum (and store it anyway)
% could really just set alpha = 0... but I like switches
momentum = 1;
% could only create these if you need them
% but I've just hard coded them in, to avoid more if loops
% if momentum
dwold = zeros(length(T(1,:)),N);
dold = zeros(N,length(I(1,:)));
% learning parameter for the momentum
alpha = 0.90;

% add a parameter to multiply the random noise added to each
% training loop
p = 0.00;
% ...doesn't seem to help much, if at all
% I'm just adding it to the training input data?
% I'll try adding it to the target instead
q = 0.01;
% also didn't seem to help much?

% initialize weights in [-1,1]
% indexed like (input node (layer 1), output node (layer 2))
W = rand(length(T(1,:)),N)*2-1;
V = rand(N,length(I(1,:)))*2-1;
% hm, reverse these so that I can multiply with them on the left
W = W';
V = V';

% if bias
% row vector of biases
% two rows with two layers
b = zeros(length(T(1,:)),2);
dbold = zeros(length(T(1,:)),2);

% internal node values
K = zeros(N,1);

% number of timesteps to train for
trainingTime = 1000;
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
        K = W*(I(j,:)+p*randn(size(I(j,:))))'+b(:,1)*bias;
        % apply sigmoid activation function
        M = sigmf(K,[1,0]);
        % prediction sum from network
        J = V*M+b(:,2)*bias;
        % final prediction
        K = sigmf(J,[1,0]);
        % of course
        % P = sigmf(V*sigmf(W*I(j,:),[1,0]),[1,0]);
        % error at each output node
        E = K-(T(j,:)'+q*randn(size(T(j,:)')));
        % compute the delta at the hidden nodes
        % transpose of V goes back
        d = E.*sigmfd(J);
        % now compute delta at the input nodes
        dw = V'*d.*sigmfd(K);
        % new weights, proportional to the gradient of cost
        % function
        W = W - eta*dw*I(j,:) - alpha*momentum*dwold;
        V = V - eta*d*K' - alpha*momentum*dold;
        dwold = eta*dw*I(j,:);
        dold = eta*d*K';
        % update the bias
        % ...could use an additional node set to 1 for bias
        % but I'll just do it directly??
        b = b - [eta*dw,eta*d] - alpha*momentum*dbold;
        dbold = [eta*dw,eta*d];
    end
    % compute total error at this timestep
    for j=1:length(I(:,1))
        errors(i) = errors(i) + sum((T(j,:)'-sigmf(V*sigmf(W*I(j,:)'+b(:,1)*bias,[1,0])+b(:,2)*bias,[1,0])).^2);
    end
    errors(i) = sqrt(errors(i)/length(I(:,1))/length(T(1,:)));
end

plot(1:trainingTime,errors)
xlabel('timestep')
ylabel('error')

% final predictions
predictions = zeros(length(I(:,1)),4);
for j=1:length(I(:,1))
    predictions(j,:) = sigmf(V*sigmf(W*I(j,:)'+b(:,1)*bias,[1,0])+b(:,2)*bias,[1,0]);
end

% now try to interpolate
a = [.5,.2,.4,.5];
predictions(4,:) = sigmf(V*sigmf(W*a'+b(:,1),[1,0])+b(:,2),[1,0]);

csvwrite('data/interpolation.csv',predictions);



