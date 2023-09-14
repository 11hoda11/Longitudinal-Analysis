% for i=1:12
% Subjects = strcat('Subject',num2str(forest(i,1)));
% SubjectID = eval(Subjects);
% end
figure;
plot(forest(:,2),forest(:,1),'MarkerFaceColor',[0 0 0],'MarkerSize',8,'Marker','square',...
    'LineStyle','none',...
    'Color',[0 0 0]);
hold on
plot(forest(:,3),forest(:,1),'MarkerFaceColor',[0 0 0],'LineStyle','none','Color',[0 0 0]);
plot(forest(:,4),forest(:,1),'MarkerFaceColor',[0 0 0],'LineStyle','none','Color',[0 0 0]);

for i=1:12
    line([forest(i,2),forest(i,3)],[forest(i,1),forest(i,1)],'LineWidth',1,'Color',[0 0 0]);
    line([forest(i,2),forest(i,4)],[forest(i,1),forest(i,1)],'LineWidth',1,'Color',[0 0 0]);

end
