clear A days day no nowalk allday eventdate meanperday

% CHANGE THE AMB NUMBER
A=datevec(AMB19_new2_dates);
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

% % CHANGE THE EVENT1 DATE
allday=no(end);
eventdate=datevec(caldiff([A(1) datetime('01-jun-2017')],{'days'}));

eventdate=eventdate(1,3);

nowalk=length(no);
meanperday=nowalk/allday;
% result=[nowalk allday meanperday]
result=[nowalk allday eventdate meanperday]
% eventdate1(1:2)=eventdate(1,3);
% % CHANGE THE AMB NUMBER
% % CHANGE THE GAIT FEATURE COLUMN
% event=[0 max(AMB17_new2(:,15))];
% 
% % CHANGE THE AMB NUMBER
% % CHANGE THE GAIT FEATURE COLUMN
% plot(no',AMB17_new2(:,15),'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
%     'MarkerSize',15,...
%     'Marker','.',...
%     'LineWidth',1);
% 
% hold on
% plot(eventdate1,event,'LineWidth',2)
