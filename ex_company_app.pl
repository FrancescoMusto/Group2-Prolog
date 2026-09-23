/*
   ex_company_app.pl
   Company application and advanced Prolog features.
*/

:- module(company_app, [
    start/0,

    works_with/2,
    people_in_department/2,
    people_with_skill/2,
    project_employee/2,

    delayed_employee/2,

    concurrent_queries/0,

    demo_error/0
]).

:- use_module('ex_company_db.pl').


/* SETUP =============================== */
start :-
    writeln('Company database loaded.').


/* PROLOG REASONING =============================== */
/* Who works with whom? */
works_with(Person1, Person2) :-
    employee(Person1, Department, _),
    employee(Person2, Department, _),
    Person1 \= Person2.


/* Find everybody in a department. */
people_in_department(Department, People) :-
    findall(
        Person,
        employee(Person, Department, _),
        People
    ).


/* Find everybody with a particular skill. */
people_with_skill(Skill, People) :-
    findall(
        Person,
        employee(Person, _, Skill),
        People
    ).


/* Which employees could work on a project? */
project_employee(Project, Person) :-
    project(Project, Department),
    employee(Person, Department, _).


/* COROUTINING =============================== */
/* Delay the employee lookup until Name is known. */
delayed_employee(Name, Department) :-

    freeze(
        Name,
        employee(Name, Department, _)
    ),

    writeln('Doing other work...'),

    choose_employee(Name).


/* Determine the employee later. */
choose_employee(Name) :-
    Name = alice.


/* CONCURRENCY =============================== */
/* Run two company queries in parallel. */
concurrent_queries :-

    spawn_workers(ThreadIDs),

    collect_results(ThreadIDs, Results),

    format('Results: ~w~n', [Results]).


/* Create worker threads. */
spawn_workers([T1, T2]) :-

    thread_self(Parent),

    thread_create(
        worker_engineering(Parent),
        T1,
        [detached(false)]
    ),

    thread_create(
        worker_prolog(Parent),
        T2,
        [detached(false)]
    ).


/* Find engineering employees. */
worker_engineering(Parent) :-
    people_in_department(engineering, People),

    thread_send_message(
        Parent,
        engineering(People)
    ).


/* Find employees with Prolog skills. */
worker_prolog(Parent) :-
    people_with_skill(prolog, People),

    thread_send_message(
        Parent,
        prolog_users(People)
    ).


/* Collect worker results. */
collect_results([T1, T2], Results) :-
    thread_get_message(engineering(Engineers)),
    thread_get_message(prolog_users(PrologUsers)),

    thread_join(T1, _),
    thread_join(T2, _),

    Results = [
        engineering-Engineers,
        prolog_users-PrologUsers
    ].


/* EXCEPTIONS =============================== */
/* Demonstrate throwing and catching an exception. */

demo_error :-

    catch(
        throw(company_error),
        Error,
        format('Caught: ~w~n', [Error])
    ).


/* TRY THESE QUERIES ===============================

   Start:
       ?- start.

   Database:
       ?- employee(Name, Department, Skill).
       ?- project(Name, Department).

   Reasoning:
       ?- works_with(alice, Person).
       ?- people_in_department(engineering, People).
       ?- people_with_skill(prolog, People).
       ?- project_employee(alpha, Person).

   Modify:
       ?- add_employee(erin, engineering, prolog).
       ?- remove_employee(erin).

   File I/O:
       ?- save_database('backup.pl').
       ?- load_database('backup.pl').

   Coroutining:
       ?- delayed_employee(Name, Department).

   Concurrency:
       ?- concurrent_queries.

   Exceptions:
       ?- demo_error.

*/
