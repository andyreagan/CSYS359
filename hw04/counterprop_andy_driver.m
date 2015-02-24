A = [1,0,0;0,1,0;0,0,1];
B = [0,0,1;0,1,0;1,0,0];

W = train_counterprop_andy(A,B);

test_counterprop_andy(A,B,W);




