% bidirectional associative memory (BAM) network
% aka heteroassociative
% accepts an input vector (hard coded here) on set of
% neurons and produces a related but different output
% vector on the other nuerons
%
% stable states are memories that are associated to eachother
% i.e. network can run in either direction
%
% I left all of my work testing the vectorization of creating the
% weight matrix :)
%
% 2015-02-13
% Andy Reagan

% threshold for output activation
mu = 0;

% define activation function
% vectorize!!
perf = @(x) x>(mu.*ones(size(x))) + (x==(mu.*ones(size(x)))).*x;

% training patterns
% are the columns
disp('training patterns:')
A = [1,0,0;0,1,0;0,0,1];
B = [0,0,1;0,1,0;1,0,0];
disp(A);
disp(B);

% size of our network
% N = 4;
% N = length(A[:,1]);
N = length(A(:,1));

% set the weights
W = zeros(N);
% with python array access
% W = A[:,1]'*B[:,1] + A[:,2]'*B[:,2] + A[:,3]'*B[:,3];
% with matlab array access
% W = A(:,1)*B(:,1)' + A(:,2)*B(:,2)' + A(:,3)*B(:,3)';
% W = (2.*A(:,1)-1)*(2.*B(:,1)-1)' + (2.*A(:,2)-1)*(2.*B(:,2)-1)' + (2.*A(:,3)-1)*(2.*B(:,3)-1)';
% disp('weights:');
% disp(W);
% matrix style!!
% W = A'*B;
% also, convert to bipolar
% disp(2.*A-1)
% disp(2.*B-1)
W = (2.*A-1)*(2.*B-1)';
disp('weights:');
disp(W);
%% test the training patterns

for j=1:length(A(1,:))
    % fetch input
    a = A(:,j)';
    % feed forward
    b = a*W;
    % apply performance rule
    b = perf(b);
    if min(a == perf(b*W')) < 1
        disp('failed test')
        disp('testing pattern')
        disp(a);
        disp('this is b')
        disp(b);
        disp('this is b put back through')
        disp(perf(b*W'))
    else
        disp('passed test')
    end
end

%% let's try to vizualize the network

% hm, going to try doing this in javascript actually!
% so that I can use network viz in d3




