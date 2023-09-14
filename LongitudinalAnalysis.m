%% Longitudinal analysis 
% making the vector for longitudinal analysis in R
% this code selects data in continuous form, i.e.
% each walk is a time point for longitudinal analysis
%-------------------------------------------------------------------
clear;
AN=input('Input 1 for after event analysis and 2 for before event analysis ');
if AN==1
load('All subjects_hoda_after.mat');
elseif AN==2
load('All subjects_hoda_before.mat');
end
allSubjectsGait = [];
hospID = hospdata(hospdata(:,2)>0);
eventID=hospdata(:,2);

p=1;

for i = 1:64
    if i < 10
        nameofMatrix_dates = strcat('AMB','0',num2str(i),'_new2_dates');
        nameofMatrix = strcat('AMB','0',num2str(i),'_new2');
        subjectID = strcat('AMB','0',num2str(i));
        daynumber=strcat('AMB','0',num2str(i),'_day');


    else
        nameofMatrix_dates = strcat('AMB',num2str(i),'_new2_dates');
        nameofMatrix = strcat('AMB',num2str(i),'_new2');
        subjectID = strcat('AMB',num2str(i));
        daynumber=strcat('AMB',num2str(i),'_day');
    end
  
  try
        subjectgait = eval(nameofMatrix);
        subjectdates = eval(nameofMatrix_dates);
        clear A days day no event
        A=datevec(subjectdates);
        A(:,4:6)=[];
        A=datetime(A);

           k=1;
        for j=2:length(A)
            days(k)=caldiff([A(j-1) A(j)],{'days'});
            k=k+1;
        end
        day=datevec(days);
        day=[[0 0 0 0 0 0];day];

        no(1)=[1];
        for j=2:length(day)
            no(j)=day(j,3)+no(j-1);
    
        end
        assignin('base',daynumber,no') 
        subjectdays = eval(daynumber);
        nodays=max(subjectdays);
   m=1; %event number of walks for after event analysis
   n=size(subjectgait,1); %number of walks for all participants
   %limiting number of days for 100 days
   for h=1:length(subjectdays)
        if subjectdays(h)>100
            n=h-1;
            nodays=100;
            break;
        end
    end
    
if AN==2 
    
%%% preparing data before event            
        for j=1:length(hospID)
            
            if hospID(j)==i && hospdata(hospID(j),5)>1 && hospdata(hospID(j),5)<=hospdata(hospID(j),4)
                   event=hospdata(hospID(j),5);
                   for h=1:length(subjectdays)
                       if subjectdays(h)>event
                       n=h;
                       break;
                       end
                    end        
            end
        end
        gaitmean(i,:)=mean(subjectgait(1:n,:));
        gaitsd(i,:)=std(subjectgait(1:n,:));  
        
        subjecttime0 = duration(datetime(subjectdates(1:n,:)) - datetime(subjectdates(1,:)));
        subjecttime = seconds(subjecttime0); % datetime in seconds format
        subjectclin=repmat(numClin(i,2:14),n,1);
        subjectnodays= repmat(hospdata(i,4),n,1);
        subjectindex = repmat(i,n,1);
        subjectevent = repmat(eventID(i),n,1);
        subjectGait= [subjectindex,subjectevent,subjecttime,subjectnodays,subjectgait(1:n,:),subjectclin]; % adding subject index
        allSubjectsGait= [allSubjectsGait;subjectGait]; % combining 10 weeks of data for all subjects together
end

if AN==1
%%% preparing data after event

    for j=1:length(hospID)
        
            if hospID(j)==i && hospdataafter(hospID(j),5)>= nodays
                del(p)=hospID(j);
                p=p+1;
                
            elseif hospID(j)==i && hospdataafter(hospID(j),5)>=1 && hospdataafter(hospID(j),5)<nodays
                event=hospdataafter(hospID(j),5);
                for l=2:length(subjectdays)
                    if subjectdays(l)>=event
                    m=l-1;
                    break
                    end
                end
            elseif hospID(j)==i && hospdataafter(hospID(j),5)<0
                event=1;
                m=1;
            
            end
            
    end
   
        gaitmean(i,:)=mean(subjectgait(m:n,:));
        gaitsd(i,:)=std(subjectgait(m:n,:));  

        subjecttime0 = duration(datetime(subjectdates(m:n,:)) - datetime(subjectdates(m,:)));
        subjecttime = seconds(subjecttime0); % datetime in seconds format
        subjectclin = repmat(numClin(i,2:14),n-m+1,1);
        subjectnodays = repmat(hospdata(i,4),n-m+1,1);
        subjectindex = repmat(i,n-m+1,1);
        subjectevent = repmat(eventID(i),n-m+1,1);
        subjectGait = [subjectindex,subjectevent,subjecttime,subjectnodays,subjectgait(m:n,:),subjectclin]; % adding subject index
        allSubjectsGait = [allSubjectsGait;subjectGait]; % combining data for all subjects together
          
 
        
        
end
%      
    catch
      end
     
     
end
    