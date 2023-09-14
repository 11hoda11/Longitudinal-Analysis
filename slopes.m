clc
clear
[Filename]=uigetfile('*.*','select the file');
[File text raw]=xlsread(Filename);
ID=File(:,1);
Time=File(:,3)./(7*86400);
Cadence=File(:,6);
n=length(File);
k=2;
e(1)=1;
for i=2:n
    if ID(i)~=ID(i-1)
      
        e(k)=i-1;
        k=k+1;
        
       
    end
end
e(end+1)=n;
for j=2:length(e)
    
  slope(j-1,:)=polyfit(Time(e(j-1):e(j)),Cadence(e(j-1):e(j)),1);
end

meanslope=mean(slope);
SDslope=std(slope);

% SEM = std(x)/sqrt(length(x));               % Standard Error
% ts = tinv([0.025  0.975],length(x)-1);      % T-Score
% CI = mean(x) + ts*SEM;

Cadence1=Cadence(e(1):e(2));
Time1=Time(e(1):e(2));

Cadence2=Cadence(e(2)+1:e(3));
Time2=Time(e(2)+1:e(3));

Cadence3=Cadence(e(3)+1:e(4));
Time3=Time(e(3)+1:e(4));

Cadence4=Cadence(e(4)+1:e(5));
Time4=Time(e(4)+1:e(5));

Cadence5=Cadence(e(5)+1:e(6));
Time5=Time(e(5)+1:e(6));

Cadence6=Cadence(e(6)+1:e(7));
Time6=Time(e(6)+1:e(7));

Cadence7=Cadence(e(7)+1:e(8));
Time7=Time(e(7)+1:e(8));

Cadence8=Cadence(e(8)+1:e(9));
Time8=Time(e(8)+1:e(9));

% Cadence9=Cadence(e(9)+1:e(10));
% Time9=Time(e(9)+1:e(10));
% 
% Cadence10=Cadence(e(10)+1:e(11));
% Time10=Time(e(10)+1:e(11));
% 
% Cadence11=Cadence(e(11)+1:e(12));
% Time11=Time(e(11)+1:e(12));
% 
% Cadence12=Cadence(e(12)+1:e(13));
% Time12=Time(e(12)+1:e(13));








