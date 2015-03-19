function a = scaling_inverse(iter)
% scale the learning paramter
% per kohonen p.1469 point 2
a = 0.9*(1-iter/10000);
end