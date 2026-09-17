% INSERT KNOWLEDGE BASE HERE: 



% ==========================

%  SECTION 1 -- BASIC COURSE QUERIES ==========================

% TODO: course_exists(+CourseID)
%   Succeeds if CourseID is in the database.
%
%   ?- course_exists(csc315).   % true
%   ?- course_exists(csc999).   % false
course_exists(CourseID) :-


% TODO: course_credits(+CourseID, -Credits)
%   Unifies Credits with the credit value of CourseID.
%
%   ?- course_credits(csc315, C).   % C = 3
%   ?- course_credits(mat150, C).   % C = 4
course_credits(CourseID, Credits) :-


%  SECTION 2 -- PREREQUISITE QUERIES ==========================

% TODO: is_immediate_prereq(+Prereq, +Course)
%   Succeeds if Prereq is a direct prerequisite of Course.
%
%   ?- is_immediate_prereq(csc270, csc315).   % true
%   ?- is_immediate_prereq(csc110, csc315).   % false (indirect only)
is_immediate_prereq(Prereq, Course) :-


% TODO: immediate_prereqs(+CourseID, -Prereqs)
%   Unifies Prereqs with the list of direct prerequisites of CourseID.
%
%   ?- immediate_prereqs(csc315, P).   % P = [csc230, csc270]
immediate_prereqs(CourseID, Prereqs) :-


% Given: all_prereqs(+CourseID, -AllPrereqs)
%   Unifies AllPrereqs with every prerequisite (direct and transitive)
%   needed before taking CourseID. No duplicates.
%
%   ?- all_prereqs(csc315, P).
%   % P = [csc230, csc220, csc110, mat150, csc270]
all_prereqs(CourseID, AllPrereqs) :-
    all_prereqs_acc(CourseID, [], AllPrereqs).

all_prereqs_acc(CourseID, Visited, AllPrereqs) :-
    findall(P, prereq(CourseID, P), DirectPrereqs),
    collect_all_prereqs(DirectPrereqs, Visited, AllPrereqs).

collect_all_prereqs([], _, []).
collect_all_prereqs([P|Rest], Visited, All) :-
    ( member(P, Visited) ->
        SubPrereqs = []
    ;
        all_prereqs_acc(P, [P|Visited], SubPrereqs)
    ),
    collect_all_prereqs(Rest, [P|Visited], RestPrereqs),
    append([P|SubPrereqs], RestPrereqs, WithDups),
    list_to_set(WithDups, All).


% Given helper function to remove duplicates from a list
% list_to_set/2 -- remove duplicates while preserving first occurrence.
list_to_set([], []).
list_to_set([H|T], [H|Set]) :-
    \+ member(H, T),
    list_to_set(T, Set).
list_to_set([H|T], Set) :-
    member(H, T),
    list_to_set(T, Set).


%  SECTION 3 -- STUDENT ELIGIBILITY ==========================

% TODO: student_completed(+StudentID, +CourseID)
%   Succeeds if the student has already completed CourseID.
%
%   ?- student_completed(s001, csc220).   % true
%   ?- student_completed(s002, csc220).   % false
student_completed(StudentID, CourseID) :-


% TODO: has_all_prereqs(+StudentID, +CourseID)
%   Succeeds if the student has completed every direct prerequisite
%   of CourseID.
%
%   ?- has_all_prereqs(s001, csc315).   % true
%   ?- has_all_prereqs(s002, csc315).   % false
has_all_prereqs(StudentID, CourseID) :-


% TODO: all_completed(+StudentID, +CourseList)
%   Succeeds if the student has completed every course in CourseList.
%   Recursive method - needs base case
all_completed(_, []).
all_completed(StudentID, [C|Rest]) :-


% TODO: can_take(+StudentID, +CourseID)
%   Succeeds if:
%     1. CourseID exists in the database.
%     2. The student has NOT already completed CourseID.
%     3. The student has completed all prerequisites.
%
%   ?- can_take(s001, csc315).   % true
%   ?- can_take(s002, csc315).   % false (missing prereqs)
%   ?- can_take(s001, csc220).   % false (already completed)
can_take(StudentID, CourseID) :-


%  SECTION 4 -- COURSE LISTINGS ==========================

% TODO: eligible_courses(+StudentID, -EligibleList)
%   Unifies EligibleList with all courses the student can take now.
%
%   ?- eligible_courses(s001, E).
eligible_courses(StudentID, EligibleList) :-


% TODO: missing_prereqs(+StudentID, +CourseID, -Missing)
%   Unifies Missing with direct prerequisites the student still needs.
%
%   ?- missing_prereqs(s002, csc315, M).   % M = [csc230, csc270]
%   ?- missing_prereqs(s001, csc315, M).   % M = []
missing_prereqs(StudentID, CourseID, Missing) :-
