function [xm,fv] = PSO (fitness,N,c1,c2,w,M,D,lower_boundary,upper_boundary)
format long;%16 significant digit

for i=1:N
	for j=1:D
		x_location(i,j)=rand(1)*(upper_boundary(j)-lower_boundary(j))+lower_boundary(j); %Randomly initialize particle positions within a specified range
		v(i,j)=randn; %Randomly initialize the speed of each particle
	end
end

%--------------Calculate the fitness of each particle--------------%
for i=1:N
%	disp(x_location(i,:))
	p(i)=fitness(x_location(i,:)); %The optimal fitness of each particle
	y(i,:)=x_location(i,:); %The optimal position of each particles
end

global_score=p(N);%the global optimal score. Default initial value is the score of the last individual
pg=x_location(N,:); %Global optimal position. Default initial value is the last individual

for i=1:N-1 %Finding the Global Optimal Location
	if p(i)>global_score
		pg=x_location(i,:);
		global_score=p(i);
	end
end
%--------------main cycle--------------%
for t=1:M
	for i=1:N
%		disp(['cycle=',num2str(t),', N=',num2str(i)])
		v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x_location(i,:))+c2*rand*(pg-x_location(i,:)); %Optimize particle speed
		x_location(i,:)=x_location(i,:)+v(i,:); %Optimize particle position
		%If the upper and lower limit is exceeded, set the boundary value
		for j=1:D
			if x_location(i,j)<lower_boundary(j)
				x_location(i,j)=lower_boundary(j);
			end
			if x_location(i,j)>upper_boundary(j)
				x_location(i,j)=upper_boundary(j);
			end
		end
		tmp_score=fitness(x_location(i,:));
		if tmp_score>p(i) %The goal is to find the highest score
			p(i)=tmp_score;%Update to individual optimal score
			y(i,:)=x_location(i,:);
			%Global updates only occur when individual updates occur
			if p(i)>global_score %Update global optimal score
				pg=y(i,:);
				global_score=p(i);
			end
		end
	end
end
xm=pg';
fv=global_score;
