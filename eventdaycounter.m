
% EventDayCounter Function
% Author: Hoda Nabavi
% Date: August 31, 2020

%% How to use this function

% subjectData = AMB19_new2_dates;  % Replace with the subject's data
% eventDate = datetime('01-jun-2017');  % Replace with the event date
% result = EventDayCounter(subjectData, eventDate);
% disp(result);  % Display the result


%% EventDayCounter Function

function result = EventDayCounter(subject_datesData, eventDate)
    % Analyze data for a specific subject.

    % Extract the date information from the subject's data
    A = datevec(subject_datesData);
    A(:, 4:6) = [];
    A = datetime(A);

    k = 1;
    for i = 2:length(A)
        days(k) = caldiff([A(i-1) A(i)], {'days'});
        k = k + 1;
    end
    day = datevec(days);
    day = [[0 0 0 0 0 0]; day];

    no(1) = 1;
    for i = 2:length(day)
        no(i) = day(i, 3) + no(i-1);
    end

    % Calculate some statistics
    allday = no(end);
    nowalk = length(no);
    meanperday = nowalk / allday;

    % Determine the event date relative to the data
    eventdate = datevec(caldiff([A(1) eventDate], {'days'}));
    eventdate = eventdate(1, 3);

    % Prepare the result
    result = [nowalk, allday, eventdate, meanperday];

    % Plot the data (you can customize this part)
    % plot(no, subjectData(:, your_gait_feature_column), 'MarkerFaceColor', [0 0.447058826684952 0.74117648601532],...
    %     'MarkerSize', 15, 'Marker', '.', 'LineWidth', 1);
    % hold on
    % plot(eventdate1, event, 'LineWidth', 2);
end
