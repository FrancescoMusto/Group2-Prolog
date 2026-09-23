/*
   company_db.pl
*/

:- module(company_db, [
    employee/3,
    project/2,
    add_employee/3,
    remove_employee/1,
    save_database/1,
    load_database/1
]).

:- dynamic employee/3.
:- dynamic project/2.


/* INITIAL DATA =============================== */

employee(alice, engineering, prolog).
employee(bob, engineering, java).
employee(carol, sales, salesforce).
employee(dave, marketing, analytics).

project(alpha, engineering).
project(beta, sales).


/* ADD / REMOVE =============================== */

/* Add an employee. */

add_employee(Name, Department, Skill) :-
    assertz(employee(Name, Department, Skill)).


/* Remove an employee. */

remove_employee(Name) :-
    retractall(employee(Name, _, _)).


/* FILE I/O =============================== */

/* Save the database to a file. */

save_database(File) :-
    open(File, write, Stream),

    forall(
        employee(Name, Department, Skill),
        (
            writeq(Stream, employee(Name, Department, Skill)),
            write(Stream, '.'),
            nl(Stream)
        )
    ),

    forall(
        project(Name, Department),
        (
            writeq(Stream, project(Name, Department)),
            write(Stream, '.'),
            nl(Stream)
        )
    ),

    close(Stream).


/* Load the database from a file. */

load_database(File) :-
    open(File, read, Stream),
    load_terms(Stream),
    close(Stream).


/* Read terms until the end of the file. */

load_terms(Stream) :-
    read_term(Stream, Term, []),

    (
        Term == end_of_file
    ->
        true
    ;
        assert_database_term(Term),
        load_terms(Stream)
    ).


/* Add valid database records. */

assert_database_term(
    employee(Name, Department, Skill)
) :-
    assertz(employee(Name, Department, Skill)).

assert_database_term(
    project(Name, Department)
) :-
    assertz(project(Name, Department)).


/* Reject invalid database records. */

assert_database_term(Term) :-
    throw(error(invalid_database_record(Term), load_database/1)).
