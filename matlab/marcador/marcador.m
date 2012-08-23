
clear all; close all; clc;
%% QlSet Model
l = 15;

Ql =[	+l		+l		0	;
		+l		-l		0	;
		-l		-l		0	;
		-l		+l		0	;
		+2*l	+2*l	0	;
		+2*l	-2*l	0	;
		-2*l	-2*l	0	;
		-2*l	+2*l	0	;
		+3*l	+3*l	0	;
		+3*l	-3*l	0	;
		-3*l	-3*l	0	;
		-3*l	+3*l	0	;
	];

centerQl(1,:) = [0			0		0];
centerQl(2,:) = [12*l+10	0		0] + centerQl(1,:);
centerQl(3,:) = [0			6*l+10	0] + centerQl(1,:);

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
