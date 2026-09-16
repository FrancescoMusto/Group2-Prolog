% ==========================================================
% PROLOG MEETING SCHEDULER
% ==========================================================
% This program demonstrates:
% facts, rules, variables, recursion, lists, arithmetic,
% logical AND/OR, negation, backtracking, and abstraction.

% Define facts of people -----------------------------------
person(alice).                              % Fact: Alice is a person.
person(bob).                                
person(charlie).                            
person(diana).                              

% Define facts of days -----------------------------------
day(monday).                                % A possible meeting day.
day(tuesday).                               
day(wednesday).                             
day(thursday).                              
day(friday).                                

% Time slots -----------------------------------
time(9).                                     % 9 AM is a possible time.
time(10).                                    
time(11).                                    
time(13).                                    
time(14).                                    
time(15).                                    

% Rooms - room(Name, Capacity) -----------------------------------
room(blue, 6).                               % Blue room seats 6.
room(green, 10).                             
room(red, 20).                               

% Availability per person - available(Person, Day, Time) -----------------------------------
available(alice, monday, 10).
available(alice, monday, 11).
available(alice, tuesday, 13).
available(alice, wednesday, 14).
available(alice, thursday, 10).

available(bob, monday, 9).
available(bob, monday, 11).
available(bob, tuesday, 13).
available(bob, tuesday, 14).
available(bob, wednesday, 14).

available(charlie, monday, 10).
available(charlie, tuesday, 13).
available(charlie, tuesday, 14).
available(charlie, wednesday, 14).
available(charlie, thursday, 10).

available(diana, monday, 11).
available(diana, tuesday, 13).
available(diana, wednesday, 14).
available(diana, thursday, 10).
available(diana, thursday, 11).

% Room availability - room_available(Room, Day, Time) -----------------------------------
room_available(blue, monday, 10).
room_available(blue, monday, 11).
room_available(blue, tuesday, 13).
room_available(blue, wednesday, 14).

room_available(green, monday, 9).
room_available(green, monday, 11).
room_available(green, tuesday, 13).
room_available(green, tuesday, 14).
room_available(green, thursday, 10).

room_available(red, tuesday, 13).
room_available(red, tuesday, 14).
room_available(red, wednesday, 14).
room_available(red, thursday, 10).

% Meeting config -----------------------------------
meeting_size(6).                            % Six people must fit.

% Check all available -----------------------------------
% Recursion checks every person in the list.
everyone_available([], _, _).                % Base case: nobody left to check.

everyone_available([Person|Rest], Day, Time) :-
    available(Person, Day, Time),            % Current person must be available.
    everyone_available(Rest, Day, Time).     % Recursively check everyone else.

% Find valid room -----------------------------------
% A room is valid if it exists, is free, and is large enough.
valid_room(Room, Day, Time) :-
    room(Room, Capacity),                    % Find room and its capacity.
    room_available(Room, Day, Time),         % Room must be available.
    meeting_size(Size),                      % Get required meeting size.
    Capacity >= Size.                        % Capacity must be sufficient.

% Find valid time -----------------------------------
% Meetings must occur between 10 AM and 3 PM.
reasonable_time(Time) :-
    time(Time),                              % Time must be an allowed slot.
    Time >= 10,                              % Not before 10 AM.
    Time =< 15.                              % Not after 3 PM.

% Find valid day -----------------------------------
% Friday meetings are not allowed.
reasonable_day(Day) :-
    day(Day),                                % Day must be a valid day.
    Day \= friday.                           % Friday is excluded.

% Find valid meeting -----------------------------------
valid_meeting(People, Day, Time, Room) :-
    reasonable_day(Day),                     % Check the day.
    reasonable_time(Time),                   % Check the time.
    everyone_available(People, Day, Time),   % Everyone must be free.
    valid_room(Room, Day, Time).             % A suitable room is required.

% Staff list -----------------------------------
all_staff([alice, bob, charlie, diana]).     % Store the team as a list.

% Find a meeting -----------------------------------
find_meeting(Day, Time, Room) :-
    all_staff(People),                       % Get the list of employees.
    valid_meeting(People, Day, Time, Room).  % Find a valid combination.

% Find early meeting -----------------------------------
% Adds an additional constraint to the search.
early_meeting(Day, Time, Room) :-
    find_meeting(Day, Time, Room),           % First find a valid meeting.
    Time =< 13.                              % Then restrict it to 1 PM or earlier.


% Define preferred rooms -----------------------------------
% Multiple facts create alternative solutions.
preferred_room(blue).                       % Blue is preferred.
preferred_room(green).                      % Green is also preferred.

preferred_meeting(Day, Time, Room) :-
    find_meeting(Day, Time, Room),           % Find a valid meeting.
    preferred_room(Room).                    % Room must be preferred.

% Display all people in knowledgebase recursively  -----------------------------------
show_people([]).                             % Base case: empty list is finished.

show_people([Person|Rest]) :-
    write(Person),                           % Display the current person.
    nl,                                      % Move to the next line.
    show_people(Rest).                       % Recursively process the rest.

% Display a meeting -----------------------------------
show_meeting(Day, Time, Room) :-
    write('Meeting: '),                      % Print text.
    write(Day),                              % Print the day.
    write(' at '),                           % Print text.
    write(Time),                             % Print the time.
    write(':00 in the '),                    % Print text.
    write(Room),                             % Print the room.
    write(' room.'),                         % Finish the message.
    nl.                                      % New line.

% Display a schedule -----------------------------------
schedule_team :-
    find_meeting(Day, Time, Room),            % Search for a meeting.
    show_meeting(Day, Time, Room).            % Display the result.

% Find all possible meetings -----------------------------------
% fail/0 forces Prolog to backtrack and find more solutions.

all_meetings :-
    find_meeting(Day, Time, Room),            % Find one solution.
    show_meeting(Day, Time, Room),            % Display it.
    fail.                                     % Force another search.

all_meetings.                                 % Stop after all solutions.
