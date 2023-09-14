
%%% Data preparation for Longitudinal Analysis

% Input is a MATLAB workspace file including gait variables for all participants
% Output is a matrix prepared for longitudinal analysis in R
% each walk is a time point for longitudinal analysis

%% Loding data
clear;

% Prompt the user for analysis type
AN = input('Input 1 for after-event analysis and 2 for before-event analysis: ');

% Load data based on user input
if AN == 1
    load('FileName_before.mat');
elseif AN == 2
    load('FileName_after.mat');
end

allSubjectsGait = [];

% Load hospitalization data  
load('FileName_hospdata.mat');
hospID = hospdata(hospdata(:,2)>0);
eventID=hospdata(:,2);

%% Reading subject's data based on subject IDs
p = 1;

for i = 1:64
    if i < 10
        subjectID = strcat('AMB0', num2str(i));
    else
        subjectID = strcat('AMB', num2str(i));
    end
    
    daynumber = strcat(subjectID, '_day');
    
    try
        subjectgait = eval(strcat(subjectID, '_new2'));
        subjectdates = eval(strcat(subjectID, '_new2_dates'));
        A = datevec(subjectdates);
        A(:, 4:6) = [];
        A = datetime(A);
        
        k = 1;
        for j = 2:length(A)
            days(k) = caldiff([A(j-1) A(j)], {'days'});
            k = k + 1;
        end
        
        day = datevec(days);
        day = [[0 0 0 0 0 0]; day];
        
        no(1) = 1;
        for j = 2:length(day)
            no(j) = day(j, 3) + no(j-1);
        end
        
        assignin('base', daynumber, no');
        subjectdays = eval(daynumber);
        nodays = max(subjectdays);
        
        m = 1; % event number of walks for after-event analysis
        n = size(subjectgait, 1); % number of walks for all participants
        
        % Limiting number of days to 100
        for h = 1:length(subjectdays)
            if subjectdays(h) > 100
                n = h - 1;
                nodays = 100;
                break;
            end
        end
%% Crop data based on hospitalization information     
        if AN == 2
            % Preparing data before the event
            for j = 1:length(hospID)
                if hospID(j) == i && hospdata(hospID(j), 5) > 1 && hospdata(hospID(j), 5) <= hospdata(hospID(j), 4)
                    event = hospdata(hospID(j), 5);
                    for h = 1:length(subjectdays)
                        if subjectdays(h) > event
                            n = h;
                            break;
                        end
                    end
                end
            end
            
            gaitmean(i, :) = mean(subjectgait(1:n, :));
            gaitsd(i, :) = std(subjectgait(1:n, :));
            
            subjecttime0 = duration(datetime(subjectdates(1:n, :)) - datetime(subjectdates(1, :)));
            subjecttime = seconds(subjecttime0);
            subjectclin = repmat(numClin(i, 2:14), n, 1);
            subjectnodays = repmat(hospdata(i, 4), n, 1);
            subjectindex = repmat(i, n, 1);
            subjectevent = repmat(eventID(i), n, 1);
            subjectGait = [subjectindex, subjectevent, subjecttime, subjectnodays, subjectgait(1:n, :), subjectclin];
            allSubjectsGait = [allSubjectsGait; subjectGait];
        end
        
        if AN == 1
            % Preparing data after the event
            for j = 1:length(hospID)
                if hospID(j) == i && hospdataafter(hospID(j), 5) >= nodays
                    del(p) = hospID(j);
                    p = p + 1;
                elseif hospID(j) == i && hospdataafter(hospID(j), 5) >= 1 && hospdataafter(hospID(j), 5) < nodays
                    event = hospdataafter(hospID(j), 5);
                    for l = 2:length(subjectdays)
                        if subjectdays(l) >= event
                            m = l - 1;
                            break;
                        end
                    end
                elseif hospID(j) == i && hospdataafter(hospID(j), 5) < 0
                    event = 1;
                    m = 1;
                end
            end
            
            gaitmean(i, :) = mean(subjectgait(m:n, :));
            gaitsd(i, :) = std(subjectgait(m:n, :));
            
            subjecttime0 = duration(datetime(subjectdates(m:n, :)) - datetime(subjectdates(m, :)));
            subjecttime = seconds(subjecttime0);
            subjectclin = repmat(numClin(i, 2:14), n - m + 1, 1);
            subjectnodays = repmat(hospdata(i, 4), n - m + 1, 1);
            subjectindex = repmat(i, n - m + 1, 1);
            subjectevent = repmat(eventID(i), n - m + 1, 1);
            subjectGait = [subjectindex, subjectevent, subjecttime, subjectnodays, subjectgait(m:n, :), subjectclin];
            allSubjectsGait = [allSubjectsGait; subjectGait];
        end
    catch
    end
end
