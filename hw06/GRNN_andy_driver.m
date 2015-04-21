clear all
close all

fprintf('time for GRNN\n');

% [X,Y] = makeTrainingData;

% disp(size(X));
% disp(size(Y));
% num_patterns = size(X,1);

% % figure(111);
% % plot(X(:,1),Y)
% % saveas(111,'figures/training_output.png')

% % no training, but let's set the weight matrices explicitly
% % first layer:
% P = X';
% % that was easy...
% % second layer (summation units):
% num_A_units = size(Y,2);
% num_B_units = size(Y,2);
% S = Y';

% % ...that's it!

% % now let's test it with an input
% x = [2,2.7];

% sigma = 0.5;

% % in a couple steps...
% % pattern_output = sigmf(sum(abs(P-repmat(x,num_patterns,1)'),1),[10 0.5]);
% pattern_output = exp(-sum(abs(P-repmat(x,num_patterns,1)'),1)./(2*sigma^2));
% summation_a_units = pattern_output*S';
% summation_b_units = pattern_output*ones(num_patterns,num_B_units);
% output = summation_a_units/summation_b_units;

% figure(112)
% plot(X(:,1),Y,'b')
% hold on;
% plot(x(1),output,'bs')
% plot(X(:,2),Y,'r')
% plot(x(2),output,'rs')
% xlabel('x_1,x_2','FontSize',12)
% ylabel('y','FontSize',12)
% legend('y over x_1','GRNN output over x_1','y over x_2','GRNN output over x_2','FontSize',12)
% saveas(112,'figures/GRNN.png')

% allx = 0:.1:10
% output = zeros(size(allx))
% for i=1:length(allx)
%     x = [allx(i),allx(i)];
%     pattern_output = exp(-sum(abs(P-repmat(x,num_patterns,1)'),1)./(2*sigma^2));
%     summation_a_units = pattern_output*S';
%     summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%     output(i) = summation_a_units/summation_b_units;
% end

% figure(113)
% plot(allx,output,'b')
% hold on;
% plot(allx,f(allx)+f(allx+1),'r')
% xlabel('x_1','FontSize',12)
% ylabel('y','FontSize',12)
% legend('GRNN output over x_1','hidden function')
% saveas(113,'figures/GRNN-allx.png')

raw = csvread('TrainData.csv');
X = raw(:,1);
% make an exact Y that I can test against!
Y = sigmf(X,[2,0])*2-1;
% Y = raw(:,2);
num_patterns = size(X,1);

% first layer:
P = X'./max(X); % and scale it to [0,1]
% second layer (summation units):
num_A_units = size(Y,2);
num_B_units = size(Y,2);
S = Y';

% sigma = 0.5;
% predict = csvread('PredictData.csv');

% output = zeros(size(predict))
% for i=1:length(predict)
%     x = predict(i)/max(X);
%     pattern_output = exp(-sum(abs(P-repmat(x,num_patterns,1)'),1)./(2*sigma^2));
%     summation_a_units = pattern_output*S';
%     summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%     output(i) = summation_a_units/summation_b_units;
% end

% figure(114)
% plot(X,Y,'b')
% hold on;
% plot(predict,output,'rs')
% xlabel('x','FontSize',12)
% ylabel('y','FontSize',12)
% legend('training data','predictions \sigma = 0.5')
% saveas(114,'figures/GRNN-givenData.png')

% sigmas = 0.1:0.1:0.9;
% % sigmas = 0.01:.01:0.1;
% predict = csvread('PredictData.csv');

% output = zeros(size(predict,1),length(sigmas));
% for j=1:length(sigmas)
%     sigma = sigmas(j);
%     for i=1:length(predict)
%         x = predict(i)/max(X);
%         pattern_output = exp(-sum(abs(P-repmat(x,num_patterns,1)'),1)./(2*sigma^2));
%         summation_a_units = pattern_output*S';
%         summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%         output(j,i) = summation_a_units/summation_b_units;
%     end
% end

% figure(115)
% plot(X,Y,'b')
% hold on;
% for j=1:length(sigmas)
%     plot(predict,output(j,:),'rs-')
% end
% % plot(predict,output,'s-')
% xlabel('x','FontSize',12)
% ylabel('y','FontSize',12)
% legend('training data','predictions \sigma=0.1',['predictions ' ...
%                     '\sigma=0.2'],'predictions \sigma=0.3','...')
% saveas(115,'figures/GRNN-givenData-allsigma.png')

% output = zeros(size(predict))
% for i=1:length(predict)
%     x = predict(i)/max(X);
%     pattern_output = exp(-sum((P-repmat(x,num_patterns,1)').^2,1)./(2*sigma^2));
%     summation_a_units = pattern_output*S';
%     summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%     output(i) = summation_a_units/summation_b_units;
% end

% figure(116)
% plot(X,Y,'b')
% hold on;
% plot(predict,output,'rs')
% xlabel('x','FontSize',12)
% ylabel('y','FontSize',12)
% legend('training data','predictions')
% saveas(116,'figures/GRNN-givenData-sqdiff.png')

% sigmas = 0.1:0.1:0.9;
% predict = csvread('PredictData.csv');

% output = zeros(size(predict,1),length(sigmas));
% for j=1:length(sigmas)
%     sigma = sigmas(j);
%     for i=1:length(predict)
%         x = predict(i)/max(X);
%         pattern_output = exp(-sum((P-repmat(x,num_patterns,1)').^2,1)./(2*sigma^2));
%         summation_a_units = pattern_output*S';
%         summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%         output(j,i) = summation_a_units/summation_b_units;
%     end
% end

% figure(117)
% plot(X,Y,'b')
% hold on;
% for j=1:length(sigmas)
%     plot(predict,output(j,:),'rs-')
% end
% xlabel('x','FontSize',12)
% ylabel('y','FontSize',12)
% legend('training data','predictions \sigma=0.1',['predictions ' ...
%                     '\sigma=0.2'],'predictions \sigma=0.3','...')
% saveas(117,'figures/GRNN-givenData-allsigma-sqdiff.png')

% exact = Y(1:5:21)';

% sigmas = 0.001:0.001:0.01;
% output = zeros(length(sigmas),size(predict,1));
% for j=1:length(sigmas)
%     sigma = sigmas(j);
%     for i=1:length(predict)
%         x = predict(i)/max(X);
%         pattern_output = exp(-sum((P-repmat(x,num_patterns,1)').^2,1)./(2*sigma^2));
%         summation_a_units = pattern_output*S';
%         summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%         output(j,i) = summation_a_units/summation_b_units;
%     end
% end

% figure(118)
% errors = zeros(size(sigmas));
% for j=1:length(sigmas)
%     errors(j) = rmse(output(j,1:2:9),exact);
% end
% plot(sigmas,errors)
% xlabel('\sigma','FontSize',12)
% ylabel('RMSE','FontSize',12)
% legend('training data','predictions \sigma=0.1',['predictions ' ...
%                     '\sigma=0.2'],'predictions \sigma=0.3','...')
% saveas(118,'figures/GRNN-givenData-allsigma-sqdiff-RMSE.png')

% prevoutput = output;

% sigma = 0.001;
% allx = 0:.01:2.5
% output = zeros(size(allx))
% for i=1:length(allx)
%     x = allx(i)/max(X);
%     pattern_output = exp(-sum((P-repmat(x,num_patterns,1)').^2,1)./(2*sigma^2));
%     summation_a_units = pattern_output*S';
%     summation_b_units = pattern_output*ones(num_patterns,num_B_units);
%     output(i) = summation_a_units/summation_b_units;
% end 

% figure(119)
% plot(X,Y,'b')
% hold on;
% plot(allx,output,'r-')
% plot(predict,prevoutput(1,:),'rs')
% xlabel('x','FontSize',12)
% ylabel('y','FontSize',12)
% legend('training data','predictions \sigma=0.001')
% saveas(119,'figures/GRNN-givenData-sigma0.001-sqdiff.png')

predict = 0:0.01:2.5;
exact = sigmf(predict,[2,0])*2-1;
sigmas = 0.01:0.001:0.1;
output = zeros(length(sigmas),size(predict,1));
for j=1:length(sigmas)
    sigma = sigmas(j);
    for i=1:length(predict)
        x = predict(i)/max(X);
        pattern_output = exp(-sum((P-repmat(x,num_patterns,1)').^2,1)./(2*sigma^2));
        summation_a_units = pattern_output*S';
        summation_b_units = pattern_output*ones(num_patterns,num_B_units);
        output(j,i) = summation_a_units/summation_b_units;
    end
end

errors = zeros(size(sigmas));
for j=1:length(sigmas)
    errors(j) = rmse(output(j,:),exact);
end

figure(120)
plot(sigmas,errors)
xlabel('\sigma','FontSize',12)
ylabel('RMSE','FontSize',12)
saveas(120,'figures/GRNN-givenData-allsigma-sqdiff-RMSE-correct.png')
