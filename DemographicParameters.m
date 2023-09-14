
% Demographic Parameters
% Author: Hoda Nabavi
% Date: April 4, 2021

%% Load Data for Hospitalized Participants and Non-Hospitalized
% Uncomment one of the following lines based on your analysis type:
% load('Subjects_before');
% load('Subjects_after');

% Separate subjects with hospitalization from others
k = 1;
for i = 1:length(allSubjectsGait)
    if allSubjectsGait(i, 2) ~= 0
        hospSubjects(k, :) = allSubjectsGait(i, :);
        k = k + 1;
    else 
        nonhospSubjects(k, :) = allSubjectsGait(i, :);
        k = k + 1;
    end
end

% Save the hospitalization data to an Excel file
saveHospitalExcel = input('Enter the name to save hospitalization data Excel file: ');
xlswrite(saveHospitalExcel, hospSubjects);
saveNonHospitalExcel = input('Enter the name to save non-hospitalization data Excel file: ');
xlswrite(saveNonHospitalExcel, nonhospSubjects);


%% Calculate Demographic Parameters for All Participants
load('AllSubjects');

M = 0;
F = 0;
N = 0;
for i = 1:64
    numClin1(i, :) = numClin(i, :);
    
    if numClin(i, :) == 0
        numClin1(i, :) = NaN;
    else
        N = N + 1;
    end
    
    if numClin1(i, 3) == 1
        M = M + 1;
    elseif numClin1(i, 3) == 0
        F = F + 1;
    end
end

meanAge = nanmean(numClin1(:, 2));
stdAge = nanstd(numClin1(:, 2));

meanHeight = nanmean(numClin1(:, 4));
stdHeight = nanstd(numClin1(:, 4));

meanWeight = nanmean(numClin1(:, 5));
stdWeight = nanstd(numClin1(:, 5));

demo = [N, meanAge, stdAge, (F / (F + M)) * 100, meanHeight, stdHeight, meanWeight, stdWeight];

% Save the demographic data to a file
xlswrite('demo.xlsx', demo);

%% Calculate Demographic Parameters for Hospitalized Participants
MH = 0;
FH = 0;
for i = 1:64
    for j = 1:length(hospID)
        if i == hospID(j)
            numClin1(i, :) = numClin(i, :);
            
            if numClin(i, :) == 0
                numClin1(i, :) = NaN;
            end
            
            numClin2(j, :) = numClin1(hospID(j), :);
            
            if numClin2(j, 3) == 1
                MH = MH + 1;
            elseif numClin2(j, 3) == 0
                FH = FH + 1;
            end
        end
    end
end

meanAgeH = mean(numClin2(:, 2));
stdAgeH = std(numClin2(:, 2));

meanHeightH = mean(numClin2(:, 4));
stdHeightH = std(numClin2(:, 4));

meanWeightH = mean(numClin2(:, 5));
stdWeightH = std(numClin2(:, 5));

NH = length(hospID);

demoH = [NH, meanAgeH, stdAgeH, (FH / (FH + MH)) * 100, meanHeightH, stdHeightH, meanWeightH, stdWeightH];

% Save the hospitalization demographic data to a file
xlswrite('demo_hospitalized.xlsx', demoH);


