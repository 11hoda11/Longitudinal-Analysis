%% Longitudinal analysis 
% making the vector for longitudinal analysis in R
% this code selects data in continuous form, i.e.
% each walk is a time point for longitudinal analysis
%-------------------------------------------------------------------

allSubjectsGait = [];


p=1;

for i =1:64
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
    
 
    
%%% preparing data before event            
        
        gaitmean(i,:)=mean(subjectgait(1:n,:));
        gaitsd(i,:)=std(subjectgait(1:n,:));  
        
        subjecttime0 = duration(datetime(subjectdates(1:n,:)) - datetime(subjectdates(1,:)));
        subjecttime = seconds(subjecttime0); % datetime in seconds format
        subjectclin=repmat(numClin(i,2:14),n,1);
       
        subjectindex = repmat(i,n,1);
         subjectnodays = repmat(nodays,n,1);
        subjectGait= [subjectindex,subjecttime,subjectnodays,subjectgait(1:n,:),subjectclin]; % adding subject index
        allSubjectsGait= [allSubjectsGait;subjectGait]; % combining 10 weeks of data for all subjects together



%%% preparing data after event

    
        
        

%      
    catch
      end
%      
     
end
    