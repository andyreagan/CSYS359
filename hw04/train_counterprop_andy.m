function W = train_counterprop_andy(A,B)

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
W = (2.*A(:,1)-1)*(2.*B(:,1)-1)' + (2.*A(:,2)-1)*(2.*B(:,2)-1)' + (2.*A(:,3)-1)*(2.*B(:,3)-1)';
% disp('weights:');
% disp(W);
% matrix style!!
% W = A'*B;
% also, convert to bipolar
% disp(2.*A-1)
% disp(2.*B-1)
% W = (2.*A-1)*(2.*B-1)';
disp('weights:');
disp(W);
%% test the training patterns
end
