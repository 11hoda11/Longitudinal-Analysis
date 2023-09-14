clear A days day no nowalk allday eventdate meanperday

% CHANGE THE AMB NUMBER
A=datevec(AMB01_new2_dates);
A(:,4:6)=[];
A=datetime(A);

k=1;
for i=2:length(A)
    days(k)=caldiff([A(i-1) A(i)],{'days'});
    k=k+1;
end
day=datevec(days);
day=[[0 0 0 0 0 0];day];

no(1)=[1];
for i=2:length(day)
    no(i)=day(i,3)+no(i-1);
    
end
assignin('base',daynumber,no') 