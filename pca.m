saved_name = 'TRAIN';
s = load('TRAINTEST2D.mat',saved_name);
d = s.(saved_name);
data = d{1,4};

Z1 = data{1,1};
Z2 = data{1,2};
Z3 = data{1,3};

Z = cat(1,rotdim(Z1),rotdim(Z2),rotdim(Z3));
covZ = cov(Z);
[v,lambda] = eigs(covZ);
v1 = v(:,1);


zeroVect = zeros(17,1);

nZ1 = rotdim(Z1) * v1;
plot(nZ1,zeroVect,'r*','MarkerSize',8);
hold on;

nZ2 = rotdim(Z2) * v1;
plot(nZ2,zeroVect,'gs','MarkerSize',8);
hold on;

nZ3 = rotdim(Z3) * v1;
plot(nZ3,zeroVect,'b.','MarkerSize',8);
title('Training Data');
pause;


saved_name = 'TEST';
s = load('TRAINTEST2D.mat',saved_name);
d = s.(saved_name);
data = d{1,4};

Z1 = data{1,1};
Z2 = data{1,2};
Z3 = data{1,3};

zeroVect = zeros(16,1);

nZ1 = rotdim(Z1) * v1;
plot(nZ1,zeroVect,'r*','MarkerSize',8);
hold on;

nZ2 = rotdim(Z2) * v1;
plot(nZ2,zeroVect,'gs','MarkerSize',8);
hold on;

nZ3 = rotdim(Z3) * v1;
plot(nZ3,zeroVect,'b.','MarkerSize',8);
title('Testing Data');
pause;

