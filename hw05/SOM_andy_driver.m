% clear all
% close all

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

numiter = 50;
% my algorithm breaks down for too many iterations....
% if I put 50, it sometimes works and sometimes doesn't
% fixed! had to use find(...,1)

% train the weight matrices
[~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0,@scaling_none,true,false);
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

[W,V,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,1,@scaling_none,true,false);

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
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0,@scaling_none,true,false);
    errors_randomVstraight(1,:) = mean(errors_all,1);
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,0,@scaling_none,true,false);
    errors_randomVstraight(2,:) = mean(errors_all,1);
end

errors_randomVstraight = errors_randomVstraight./numtrials;

figure(115)
plot(1:numiter,errors_randomVstraight)
title('counterprop convergence, 100 trials')
xlabel('iteration')
ylabel('RMSE over each training data')
legend('straight','random')
saveas(115,'115.png')

numiter = 10;

% test it now
% train one with random order
randorder = true;
[kohonen_weights,grossberg_weights,~] = train_counterprop_andy(training_norm,output_data,numiter,randorder,@scaling_none,true,false);

test_counterprop_andy(kohonen_weights,grossberg_weights,interpolation_norm,training_norm,training,'116-standard.png',false);
test_counterprop_andy(kohonen_weights,grossberg_weights,interpolation_norm,training_norm,training,'116-wpoints.png',true);

% now lets try to look at convergence with exponential scaling
numiter = 50;
errors_exp = zeros(2,numiter);
for i=1:numtrials
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_none,true,false);
    errors_exp(1,:) = mean(errors_all,1);
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_exponential,true,false);
    errors_exp(2,:) = mean(errors_all,1);
end

errors_exp = errors_exp./numtrials;

figure(117)
plot(1:numiter,errors_exp)
title('counterprop convergence, 100 trials')
xlabel('iteration')
ylabel('RMSE over each training data')
legend('no scaling','exponential scaling')
saveas(117,'117.png')

% now lets try to look at convergence separately vs together
errors_exp = zeros(2,numiter);
for i=1:numtrials
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_none,true,false);
    errors_exp(1,:) = mean(errors_all,1);
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_exponential,false,false);
    errors_exp(2,:) = mean(errors_all,1);
end

errors_exp = errors_exp./numtrials;

figure(118)
plot(1:numiter,errors_exp)
title('counterprop convergence, 100 trials')
xlabel('iteration')
ylabel('RMSE over each training data')
legend('together','separate')
saveas(118,'118.png')

% now lets try to look at convergence w nearest neighbor
numiter = 50;
errors_exp = zeros(2,numiter);
for i=1:numtrials
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_none,false,true);
    errors_exp(1,:) = mean(errors_all,1);
    [~,~,errors_all] = train_counterprop_andy(training_norm,output_data,numiter,false,@scaling_exponential,false,true);
    errors_exp(2,:) = mean(errors_all,1);
end

errors_exp = errors_exp./numtrials;

figure(119)
plot(1:numiter,errors_exp)
title('counterprop convergence, 100 trials')
xlabel('iteration')
ylabel('RMSE over each training data')
legend('normal','nearest neighbor')
saveas(119,'119.png')

% test randomorder on the 2D space
numiter = 50;
% i'm not sure averaging over weights makes any real sense
% averaging over convergence does, but not weights
numtrials = 1;
% for i=1:numtrials
randorder = true;
[kohonen_weightsr,grossberg_weightsr,~] = train_counterprop_andy(training_norm,output_data,numiter,randorder,@scaling_none,true,false);
randorder = false;
[kohonen_weights,grossberg_weights,~] = train_counterprop_andy(training_norm,output_data,numiter,randorder,@scaling_none,true,false);
% end
test_counterprop_andy(kohonen_weightsr,grossberg_weightsr,interpolation_norm,training_norm,training,'interpolation-randorder.png',false);
test_counterprop_andy(kohonen_weights,grossberg_weights,interpolation_norm,training_norm,training,'interpolation-straigtorder.png',true);

% test nearest neighbor in 2d
numiter = 50;
randorder = false;
[kohonen_weightsr,grossberg_weightsr,~] = train_counterprop_andy(training_norm,output_data,numiter,randorder,@scaling_none,false,false);
[kohonen_weights,grossberg_weights,~] = train_counterprop_andy(training_norm,output_data,numiter,randorder,@scaling_none,false,true);
test_counterprop_andy(kohonen_weightsr,grossberg_weightsr,interpolation_norm,training_norm,training,'interpolation-random.png',false);
test_counterprop_andy(kohonen_weights,grossberg_weights,interpolation_norm,training_norm,training,'interpolation-nearestn.png',true);



