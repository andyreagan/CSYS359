function [x,y] = makeTrainingData()
% sample points, 1D, randomly
% x = linspace(0,10,100);
x1 = rand(100,1)*10;
x1 = sort(x1);

x2 = rand(100,1)*10;
x2 = sort(x2);

x = [x1,x2];

% sample those points, with error
y_error = 1;
y = f(x1)+f(x2+1)+rand(size(x1))*2*y_error-y_error;

end

