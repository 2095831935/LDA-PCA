saved_name = 'TRAIN';
s = load('TRAINTEST2D.mat',saved_name);
d = s.(saved_name);
data = d{1,4};

Z1 = rotdim(data{1,1});
X1 = Z1(:,1);
Y1 = Z1(:,2);

Z2 = rotdim(data{1,2});
X2 = Z2(:,1);
Y2 = Z2(:,2);

Z3 = rotdim(data{1,3});
X3 = Z3(:,1);
Y3 = Z3(:,2);

plot(X1,Y1,'r*','MarkerSize',8);
hold on;
plot(X2,Y2,'gs','MarkerSize',8);
hold on;
plot(X3,Y3,'b.','MarkerSize',8);
pause;

Z = cat(1,Z1,Z2,Z3);

indiZ = [ Z1 Z2 Z3];

function R = GaussianKernel(X,Y)

%power = (X - Y)*(X - Y)';
power = sum((X-Y).^2);

R = exp(-1*power/2*1);


return;

end


MStar = zeros(length(Z),1);

for i = 1:length(MStar)

	for j = 1:length(Z)
		MStar(i,1) += GaussianKernel(Z(i,:),Z(j,:));
	endfor

	MStar(i,1) = MStar(i,1) / length(Z);

endfor

M = zeros(length(Z),3);

for i = 1:3
	
	temp = i*2;

	for j = 1:length(Z)
		
		for z = 1:length(indiZ(:,temp-1:temp))
			M(j,i) += GaussianKernel(Z(j,:),indiZ(z,temp-1:temp));
		endfor

		M(j,i) = M(j,i) / length(indiZ(:,temp-1:temp));


	endfor
endfor

K1 = zeros(length(Z),length(Z1));
K2 = zeros(length(Z),length(Z2));
K3 = zeros(length(Z),length(Z3));

for i = 1:length(Z)

	for j = 1:length(Z1)
		K1(i,j) = GaussianKernel(Z(i,:),indiZ(j,1:2));
	endfor

	for j = 1:length(Z2)
		K2(i,j) = GaussianKernel(Z(i,:),indiZ(j,3:4));
	endfor

	for j = 1:length(Z3)
		K3(i,j) = GaussianKernel(Z(i,:),indiZ(j,5:6));
	endfor

endfor

I = eye(length(Z1));
T1 = 1/17 * ones(length(Z1));

T2 = I - T1; 

N = K1*T2*K1' + K2*T2*K2' + K3*T2*K3';

VeraM = zeros(length(Z));

for i = 1:3
	temp = i*2;

	VeraM += 17 * (M(:,i) - MStar) * (M(:,i) - MStar)';

endfor

Matrx  = pinv(N + 0.1 * eye(length(N)))*VeraM;

[v,lambda] = eigs(Matrx);

v1 = v(:,6);

#{
saved_name = 'TEST';
s = load('TRAINTEST2D.mat',saved_name);
d = s.(saved_name);
data = d{1,4};

Z1 = rotdim(data{1,1});

Z2 = rotdim(data{1,2});

Z3 = rotdim(data{1,3});

indiZ = [ Z1 Z2 Z3];
#}

zeroVect = zeros(length(Z1),1);

nZ1 = zeros(length(Z1),1);
for i = 1:length(Z1)
	K = zeros(length(Z),1);
	for j = 1:length(Z)
		K(j) = GaussianKernel(indiZ(i,1:2),Z(j,:));
	endfor
	nZ1(i,1) = v1' * K;
endfor

plot(nZ1,zeroVect,'r*','MarkerSize',8);
hold on;

nZ2 = zeros(length(Z1),1);
for i = 1:length(Z1)
	K = zeros(length(Z),1);
	for j = 1:length(Z)
		K(j) = GaussianKernel(indiZ(i,3:4),Z(j,:));
	endfor
	nZ2(i,1) = v1' * K;
endfor

plot(nZ2,zeroVect,'gs','MarkerSize',8);
hold on;

nZ3 = zeros(length(Z1),1);
for i = 1:length(Z1)
	K = zeros(length(Z),1);
	for j = 1:length(Z)
		K(j) = GaussianKernel(indiZ(i,5:6),Z(j,:));
	endfor
	nZ3(i,1) = v1' * K;
endfor

plot(nZ3,zeroVect,'b.','MarkerSize',8);
title("Testing Data");
pause;
