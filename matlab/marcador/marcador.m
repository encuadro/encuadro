
clear all; close all; clc;
%% QlSet Model
l = 30.8;

Ql =[	+32		+32		0	;
		+32		-32		0	;
		-32		-32		0	;
		-32		+32		0	;
		+63     +63     0	;
		+63     -63     0	;
		-63     -63     0	;
		-63     +63     0	;
		+93     +93     0	;
		+93     -93     0	;
		-93     -93     0	;
		-93     +93 	0	;
	];

centerQl(1,:) = [-787/2 -445/2 0];
centerQl(2,:) = [787 0 0] + centerQl(1,:);
centerQl(3,:) = [0 445 0] + centerQl(1,:);

QlSet = zeros(12,3,3);
for i=1:3
	for j=1:12
		QlSet(j,:,i)=Ql(j,:)+centerQl(i,:);
	end
	plot(QlSet(:,1,i),QlSet(:,2,i),'o'); hold on;
end
xlabel('x')
ylabel('y')
axis equal;
hold off;

%% Print to file or cmdline in c language format

varName = 'object';

template = '%s[%d][%d] = %d;\n';


indice = 0;
for i=1:3
	fprintf('//QlSet%d\n',i-1);	
	for j=1:12
			fprintf(template,varName,indice,0,QlSet(j,1,i));
			fprintf(template,varName,indice,1,QlSet(j,2,i));
			fprintf(template,varName,indice,2,QlSet(j,3,i));
			indice=indice+1;
	end
end

%% Print to file or cmdline in c language format

fp=fopen('MarkerQR2.txt','w');


template = '%f %f %f\n';


for i=1:3
	for j=1:12
			fprintf(fp,template,QlSet(j,:,i));
	end
end

fclose(fp)
