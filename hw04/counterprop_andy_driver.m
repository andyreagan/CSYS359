clear all
close all

% load the data
training = csvread('CounterProp_Data.csv');

num_output_categories = max(training(:,end));
output_data = zeros(length(training(:,1)),num_output_categories);
for i=1:length(training(:,1))
    output_data(i,end+1-training(i,end)) = 1;
end

% make the interpolation data set
% looks like the x and y in the training data
% go close to 200 and 250, respectively
% so interpolation at every point up to those
[X,Y] = meshgrid(1:200,1:250);
interpolation = [X(:),Y(:)];

% normalize the data to the unit sphere
[training_norm,interpolation_norm] = nomalize_input_andy(training(:,1:end-1),interpolation);

% tell me what happened
fprintf('size of training is: \n');
disp(size(training));
fprintf('size of training_norm is: \n');
disp(size(training_norm));
fprintf('first row of training is: \n');
disp(training(1,:));
fprintf('first row of training_norm is: \n');
disp(training_norm(1,:));
fprintf('length of first row of training is (should be 1): \n');
disp(sum(training_norm(1,:).^2));
fprintf('length of first row of interpolation is (should be 1): \n');
disp(sum(interpolation_norm(1,:).^2));

numiter = 100;
% my algorithm breaks down for too many iterations....
% if I put 50, it sometimes works and sometimes doesn't

% train the weight matrices
[W,V,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0);
% again, tell me what happened
% disp(size(V));
% disp(size(W));

figure(111)
plot(1:numiter,mean(errors_all,1))
title('convergence of counterprop')
xlabel('iteration')
ylabel('avg RMSE over training data')
saveas(111,'111.png')

figure(112)
plot(1:numiter,errors_all)
title('convergence of counterprop')
xlabel('iteration')
ylabel('RMSE over each training data')
saveas(112,'112.png')

[W,V,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,1);

figure(113)
plot(1:numiter,mean(errors_all,1))
title('convergence of counterprop, random training order')
xlabel('iteration')
ylabel('avg RMSE over training data')
saveas(113,'113.png')

figure(114)
plot(1:numiter,errors_all)
title('convergence of counterprop, random training order')
xlabel('iteration')
ylabel('RMSE over each training data')
saveas(114,'114.png')

% looking at a few of these...looks like it flattens out
% with the random order
% and the avg RMSE is about the same

% let's do a little bit better, and average over many runs for the
% RMSE plot
numtrials = 10;
errors_randomVstraight = zeros(2,numiter);
for i=1:numtrials
    [W,V,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0);
    errors_randomVstraight(1,:) = mean(errors_all,1);
    [W,V,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0);
    errors_randomVstraight(2,:) = mean(errors_all,1);
end
errors_randomVstraight = errors_randomVstraight./numtrials;

figure(115)
plot(1:numiter,errors_randomVstraight)
title('counterprop convergence, 20 trials')
xlabel('iteration')
ylabel('RMSE over each training data')
legend('straight','random')
saveas(115,'115.png')

numiter = 100;

% test it now
% train one with random order
order = true;
[kohonen_weights,grossberg_weights,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,order);

interp = test_counterprop_andy(kohonen_weights,grossberg_weights,interpolation_norm,training_norm);





