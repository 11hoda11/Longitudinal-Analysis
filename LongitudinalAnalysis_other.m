%% Longitudinal hospitalized participants

%%% for before Hospitalization
%load('All subjects_hoda_before')

%%% for after Hospitalization
%load('All subjects_hoda_after')


k=1;
for i=1:length(allSubjectsGait)
    if allSubjectsGait(i,2)~=0
        hospSubjects(k,:)=allSubjectsGait(i,:);
        k=k+1;
    end
end
xlswrite(input('save excel name >'),hospSubjects)

%% Longitudinal non-hospitalized participants

%%% for before Hospitalization
load('All subjects_hoda_before')




k=1;
for i=1:length(allSubjectsGait)
    if allSubjectsGait(i,2)==0
        nonhospSubjects(k,:)=allSubjectsGait(i,:);
        k=k+1;
    end
end
xlswrite(input('save excel name >'),nonhospSubjects)


%% Demographic parameters for All Participants


load('All subjects_hoda')

M=0;
F=0;
N=0
for i=1:64
    numClin1(i,:)=numClin(i,:);
    if numClin(i,:)==0
        numClin1(i,:)=nan;
    else
        N=N+1;
    end
    if numClin1(i,3)==1
        M=M+1;
    else if numClin1(i,3)==0
            F=F+1;
        end
    end
end

meanAge=nanmean(numClin1(:,2));
stdAge=nanstd(numClin1(:,2));

meanHeight=nanmean(numClin1(:,4));
stdHeight=nanstd(numClin1(:,4));

meanWeight=nanmean(numClin1(:,5));
stdWeight=nanstd(numClin1(:,5));

demo=[N,meanAge,stdAge,(F/(F+M))*100,meanHeight,stdHeight,meanWeight,stdWeight]
xlswrite('demo',demo)
%% Demographic parameters for Hospitalized Participants

load('All subjects_hoda')
MH=0;
FH=0;
for i=1:64
    for j=1:length(hospID)
        if i==hospID(j)
            numClin1(i,:)=numClin(i,:);
            if numClin(i,:)==0
                numClin1(i,:)=nan;
            end
   
            numClin2(j,:)=numClin1(hospID(j),:);
            
            if numClin2(j,3)==1
                MH=MH+1;
            else if numClin2(j,3)==0
                FH=FH+1;
                end
            end
        end
    end
end

meanAgeH=mean(numClin2(:,2));
stdAgeH=std(numClin2(:,2));

meanHeightH=mean(numClin2(:,4));
stdHeightH=std(numClin2(:,4));

meanWeightH=mean(numClin2(:,5));
stdWeightH=std(numClin2(:,5));
NH=length(hospID);

demoH=[NH,meanAgeH,stdAgeH,(FH/(FH+MH))*100,meanHeightH,stdHeightH,meanWeightH,stdWeightH]
demographic=[demo;demoH];
xlswrite('demographic',demographic)


%% Finding mean of gait variables

for i=1:16
   gait(:,2*i-1)=gaitmean(:,i);
   gait(:,2*i)=gaitsd(:,i);
end

for i=1:length(gait)
    if gait(i)==0
           gait(i,:)=nan;
    end
    
    AMBID(i)=i;
end
    xlswrite(input('save excel name >'),[AMBID',gait])

%%
clear
data=xlsread('longitudinal data under100days nonhosp');

ID=data(:,1);
Event=data(:,2);
Age=data(:,21);
Sex=data(:,22);
Height=data(:,23);
Weight=data(:,24);
days=data(:,4);
POMAB=data(:,25);
NPI=data(:,29);
N=1;
k=1;
for i=1:length(data)-1
   
    
    if ID(i)==ID(i+1)
        N=N+1;
    else
        data2(k,:)=data(i,:);
        NOW(k)=N; 
        k=k+1; 
        N=1;
        
    end
      
      
end   
NOW(end+1)=N;
data2(end+1,:)=data(end,:);


k=1;
l=1;
for i=1:length(data2)
    if data2(i,2)==0
        non_data(k,:)=data2(i,:);        
        non_data_walk(k)=NOW(i);
        k=k+1;
    else
        event_data(l,:)=data2(i,:);
        event_data_walk(l)=NOW(i);
        l=l+1;
    end
end

mean_non_age=mean(non_data(:,21));
SD_non_age=std(non_data(:,21));

mean_non_height=mean(non_data(:,23));
SD_non_height=std(non_data(:,23));

mean_non_weight=mean(non_data(:,24));
SD_non_weight=std(non_data(:,24));

mean_non_NOD=mean(non_data(:,4));
SD_non_NOD=std(non_data(:,4));

mean_non_NOW=mean(non_data_walk);
SD_non_NOW=std(non_data_walk);

mean_non_POMAB=mean(non_data(:,25));
SD_non_POMAB=std(non_data(:,25));

mean_non_NPI=mean(non_data(:,29));
SD_non_NPI=std(non_data(:,29));


% mean_event_age=mean(event_data(:,21));
% SD_event_age=std(event_data(:,21));
% 
% mean_event_height=mean(event_data(:,23));
% SD_event_height=std(event_data(:,23));
% 
% mean_event_weight=mean(event_data(:,24));
% SD_event_weight=std(event_data(:,24));
% 
% mean_event_NOD=mean(event_data(:,4));
% SD_event_NOD=std(event_data(:,4));
% 
% mean_event_NOW=mean(event_data_walk);
% SD_event_NOW=std(event_data_walk);
% 
% mean_event_POMAB=mean(event_data(:,25));
% SD_event_POMAB=std(event_data(:,25));
% 
% mean_event_NPI=mean(event_data(:,29));
% SD_event_NPI=std(event_data(:,29));

non_result=[mean_non_age,SD_non_age;mean_non_height,SD_non_height;mean_non_weight,SD_non_weight;mean_non_NOD,SD_non_NOD;mean_non_NOW,SD_non_NOW;mean_non_POMAB,SD_non_POMAB;mean_non_NPI,SD_non_NPI];

% event_result=[mean_event_age,SD_event_age;mean_event_height,SD_event_height;mean_event_weight,SD_event_weight;mean_event_NOD,SD_event_NOD;mean_event_NOW,SD_event_NOW;mean_event_POMAB,SD_event_POMAB;mean_event_NPI,SD_event_NPI];
