function [] = test_bam_andy(A,B,W)
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
disp(A);
disp(B);

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

end