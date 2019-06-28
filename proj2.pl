%% File : proj2.pl
%% Author: Tong-Ing Wu <tongingw@student.unimelb.edu.au>
%% ID : 1001500
%% Origin: May 11th 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This program is written to solve the maths puzzles.
%%
%% A math puzzles is a square grid of squares  each should be filled in with 
%% a single 
%% digit 1-9 satisfying the following constraints: (from the specification)
%% 
%% 1. each row and each column contains no repeated digits;
%% 2. all squares on the diagonal line from upper left to lower right contain 
%%    the same value.    
%% 3. the heading of reach row and column (leftmost square in a row and 
%%    topmost square in a column) holds either the sum or the product of 	
%%    all the digits in that row or column holds either the sum or the 
%%    product of all the digits in that row or column. 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load in CLPFD library
:-use_module(library(clpfd)).


%% This predicate will evaluate the puzzle.
puzzle_solution(Puzzle) :-
    % check if the size of the puzzle satisfying the size constraint.
    length(Puzzle, Length), Length in 3..5, 
    
    % check if the puzzle is a square.
    maplist(same_length(Puzzle), Puzzle),
   
    % get the squares without heading.
    get_squares(Puzzle, Squares), 
    
    % constraint on diagonal.
    check_diagonal(Squares,0), 
    
    % transpose the puzzle for further evaluation.
    transpose(Puzzle, PuzzleT), 
    
    % solve the puzzle
    solve_puzzle(PuzzleT),  
    solve_puzzle(Puzzle),
    
    % make all unbound values to be bound.
    maplist(label,Puzzle). 


%% This predicate will remove the heading.
get_squares([_|Ls],Square) :-
    remove_column_heading(Ls,Square).	

%% Helper predicate for get_squares. 
remove_column_heading([[_|T]|[]], [T]).
remove_column_heading([[_|T]|Ls],Squares) :-
    remove_column_heading(Ls,Sub_Squares),
    append([T], Sub_Squares, Squares).

%% This predicate will check if the diagonal fulfills the constraint.
check_diagonal([_|[]],_).
check_diagonal([L1, L2|Ls],P1) :-
    P2 is P1 + 1,
    nth0(P1, L1, E),
    nth0(P2, L2, E),
    check_diagonal([L2|Ls],P2).

%% This predicate will solve the rows of the puzzle.
solve_puzzle([_|[]]).
solve_puzzle([_,L2|Ls]) :-
    is_Valid_row(L2), % quicker
    solve_row(L2),
    solve_puzzle([L2|Ls]).

%% Helper predicate for solve a row.
solve_row([H|T]):-
    check_product(T, H);
    check_sum(T,H).

%% check if all element fulfills the constraints that all digits should be
%% distinct and are between 1 to 9.
is_Valid_row([_|L]):-
    L ins 1..9 ,
    all_distinct(L).

%% This predicate will check if the sum of a row fulfills the constraint that
%% it should be equal to the value of the heading.
check_sum([],0).
check_sum([H|T], Sum) :-
    check_sum(T, Sub_Sum),
    Sum #= H + Sub_Sum.

%% This predicate will check if the product of a row fulfills the constraint
%% that it should be equal to the value of the heading.
check_product([],1).
check_product([H|T], Product) :-
    check_product(T, Sub_Product),
    Product #= H * Sub_Product.
