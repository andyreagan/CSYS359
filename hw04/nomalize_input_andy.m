function [B,C] = nomalize_input_andy(training_patterns,interpolation_patterns)
% normalize the input using the unit sphere method
%
% none of this is vectorized....we'll wait and see if it needs to be
% ......did it anyway, the interpolation data is huge right now
%
% INPUTS
%
% training_patterns(num train patterns, size input)
% interpolation_patterns(num interp patterns, size input)
%
% OUTPUT
%
% B: normalized input

num_training_patterns = length(training_patterns(:,1));
input_size = length(training_patterns(1,:));

% B = zeros(num_training_patterns,input_size+1);
% for i=1:num_training_patterns
%     B(i,1:input_size) = training_patterns(i,:);
%     % this is the "l" from the notes
%     B(i,input_size+1) = sqrt(sum(training_patterns(i,:).^2));
% end
B = ones(num_training_patterns,input_size+1);
B(:,1:end-1) = training_patterns;
B(:,end) = sqrt(sum(training_patterns.^2,2));

num_interpolation_patterns = length(interpolation_patterns(:,1));
C = ones(num_interpolation_patterns,input_size+1);
C(:,1:end-1) = interpolation_patterns;

% l_interpolation = zeros(num_interpolation_patterns,1);
% for i=1:num_interpolation_patterns
%     % this is the "l" from the notes
%     l_interpolation(i) = sqrt(sum(interpolation_patterns(i,:).^2));
% end
C(:,end) = sqrt(sum(interpolation_patterns.^2,2));

max_l = max([max(B(:,end)),max(C(:,end))]);
N = 1.01 * max_l;

B(:,end) = sqrt(N^2-B(:,end).^2);
C(:,end) = sqrt(N^2-C(:,end).^2);

B = B/N;
C = C/N;

end
