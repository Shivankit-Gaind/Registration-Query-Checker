/*We are assuming Registration for one particular semester and the students involved either belong to a particular single degree branch with the
course structure given or a particular dual degree branch with the course structure given */

/**PLEASE REFER TO THE READ ME FILE FOR THE INPUT FORMAT AND THE WAY YOU HAVE TO BOOK THE SLOTS AS SOON AS YOU REGISTER FOR THE COURSE**/

/**ASSUME THAT ONE PARAMETER OF INPUT DOESN'T CLASH WITH THE OTHER i.e THE INPUT IS CORRECT**/



/*MEMBERSHIP RELATION*/

member(X,[X|Tail]).
member(X,[Head|Tail]):- member(X,Tail).
member(X,[Head|Tail]):-member(X,Head).

/*Function to CONCATINATE LISTS*/
conc([],L,L).
conc([X|L1],L2,[X|L3]):- conc(L1,L2,L3).

/*Function to check whether elements of one list are present in the other or not*/
allElementsInList([],L).
allElementsInList([X|Tail],L):- member(X,L), allElementsInList(Tail,L).


/*Function to make a list of courses only till 2nd year*/
conc2yr([Sem1,Sem2,Sem3,Sem4|_],X):-conc(Sem1,Sem2,X1),conc(X1,Sem3,X2),conc(X2,Sem4,X).

/*Function to make a list of courses only till 3rd year*/
conc3yr([Sem1,Sem2,Sem3,Sem4,Sem5,Sem6|_],Y):-conc(Sem1,Sem2,X1),conc(X1,Sem3,X2),conc(X2,Sem4,X3),conc(X3,Sem5,X4),conc(X4,Sem6,Y).

/*Function to make a list of courses only till 4th year(mainly required for the dualites) */
conc4yr([Sem1,Sem2,Sem3,Sem4,Sem5,Sem6,Sem7,Sem8|_],Z):-conc(Sem1,Sem2,X1),conc(X1,Sem3,X2),conc(X2,Sem4,X3),conc(X3,Sem5,X4),conc(X4,Sem6,X5),conc(X5,Sem7,X6),conc(X6,Sem8,Z).


/*List of Students whose dues are pending*/
listOf_DuesPending([rohan,sohan]).

/*List of Students who have got Backlog for the current semister*/
listOf_SemBacks([ramesh,suresh]).

/*List of Students whose gradesheets of the previous semisters are still witheld */
listOf_GradeSheetWithheld([ram]).

/*List of Students who have got Grade I or NC for any course in the previous semister*/
listOf_Grade_I_Or_NC([shyam]).

/*This is the list of students who have not completed all the Compulsary Disciplinary Courses (CDC's) till the previous semester*/
listOf_Defaulters([avinash,anany]).

/*Course structures of a single degree and a dual degree course where each sublist denotes a particular semester; so we have 6 semester CDC's for the
 single degree students and 8 semester CDC's for the dual degree students*/

listOf_Courses_Single([[bio_F111, math_F111], [cs_F111, math_F112], [cs_F214, math_F211], [cs_F211, cs_F212], [cs_F351, cs_F372], [cs_F363, cs_F303]]
).
listOf_Courses_Dual([[bio_F111, math_F111], [cs_F111, math_F112], [econ_F211, math_F211], [econ_F241, econ_F242], [econ_F311, cs_214],
		    [econ_F341, cs_F211], [econ_F311, cs_F351], [econ_F341, cs_F363]]).


/*List of HIGHER DEGREE courses belonging to a particular Branch(B.E)*/
listOf_HigherDegreeEngg([cs_G525, cs_G526, cs_G623, cs_G541, cs_F415]).

/*List of HIGHER DEGREE courses belonging to a particular Branch(M.S.C)*/
listOf_HigherDegreeSci([econ_F351, econ_F352, econ_F471, econ_F353, econ_F411]
).

/*List of Sample courses which are not the CDC'S or Higher Degree courses but the students can take them as electives*/
listOf_Other_Degree_Courses([hss_F222, hss_F236, hss_F334, hss_F325, hss_F235]).


/*List of single degree and dual degree students*/
listOf_Singlites([avinash,pragun,jitesh,rahul,rohan,ramesh,ram]).
listOf_Dualites([anany,anand,rajat,dewang,sohan,suresh,shyam]).

/**************************************************************************************************************************************************/

/*
   CLAUSE 3.09 (ACADEMIC REGULATIONS) --> A student is not permitted to register in a semester if
 (i) He/she has dues outstanding to the Institute, hostel, or any recognised organ of the Institute,or
 (ii) his/her grade sheet in his/her immediately preceding semester is withheld, or
 (iii) He/she has an ‘Incomplete’ report ‘I’ in his/her grade sheet in his/her immediately preceding semester or
 (iv) He/she has been specifically debarred or asked to stay away from that semester.

 */

generalRequirements(X):- listOf_DuesPending(L1), listOf_Grade_I_Or_NC(L2),listOf_SemBacks(L3), listOf_GradeSheetWithheld(L4),
					 \+(member(X,L1)),\+(member(X,L2)),\+(member(X,L3)),\+(member(X,L4)).



/*Clauses to check whether the student is a single degree or a dual degree student*/
is_Singlite(X):- listOf_Singlites(L),member(X,L).
is_Dualite(X):- listOf_Dualites(L1),member(X,L1).


/*Clause to check whether the student has completed all CDC courses till preceeding semester*/
isCourses_Completed_Till_Prev_Sem(X):- listOf_Defaulters(L2),\+member(X,L2).


hasCompleted_2yr_Single(L):- listOf_Courses_Single(L1),conc2yr(L1,X),allElementsInList(X,L).
hasCompleted_2yr_Dual(L):- listOf_Courses_Dual(L1),conc2yr(L1,X),allElementsInList(X,L).

hasCompleted_3yr_Single(L):- listOf_Courses_Single(L1),conc3yr(L1,X),allElementsInList(X,L).
hasCompleted_3yr_Dual(L):- listOf_Courses_Dual(L1),conc3yr(L1,X),allElementsInList(X,L).

hasCompleted_4yr_Dual(L):- listOf_Courses_Dual(L1),conc4yr(L1,X),allElementsInList(X,L).


/*Clause to check whether the prerequisites of a particular course belong to the list of the courses the person has already done*/
preRequisitesDone(L,L1):- allElementsInList(L1,L).


/*Clauses to check the category to which the course belongs by checking the membership relation*/

isCourse_HigherDegreeEngg(X):- listOf_HigherDegreeEngg(L), member(X,L).

isCourse_HigherDegreeSci(X):- listOf_HigherDegreeSci(L), member(X,L).

is_CDC(X,STUDENT):- (is_Singlite(STUDENT), listOf_Courses_Single(L1),member(X,L1) );(is_Dualite(STUDENT),listOf_Courses_Dual(L2),member(X,L2)).

is_CourseOf_Other_Degree(X):- listOf_Other_Degree_Courses(L), member(X,L).


/**BOOKED TIME SLOTS**/

slot_booked(2-1).
slot_booked(2-5).

/***************************************************************************************************************************************************/

/* Clause 3.14 (ACADEMIC REGULATIONS) ----> A student can register for PS1 if he/she has completed all the courses till 2nd year*/

register_For_PS1(STUDENT,L):- generalRequirements(STUDENT),
			     ((is_Singlite(STUDENT),hasCompleted_2yr_Single(L));(is_Dualite(STUDENT),hasCompleted_2yr_Dual(L))).

/* Clause 3.14 (ACADEMIC REGULATIONS) ----> A student can register for PS2 if he/she has completed all the courses till 3nd year
(for single degree student) or 4th year (dual degree student)*/

register_For_PS2(STUDENT,L):- generalRequirements(STUDENT),
			     ((is_Singlite(STUDENT),hasCompleted_3yr_Single(L));(is_Dualite(STUDENT),hasCompleted_4yr_Dual(L))).

/**************************************************************************************************************************************************/

/* Clause 3.15 (ACADEMIC REGULATIONS) ----> A student can register for courses of a higher degree of his/her own discipline(s) after completing:
---> After clearing first set of his/her own Discipline core courses in the case of single degree.
---> After clearing the first set of his/her Discipline core courses of the corresponding degree in the case of dual degree.

Note that the first set of Discipline core courses are prescribed in the second year of the semester wise pattern of a single degree student;
in the second year for the first degree and in the third year for the second degree of a dual degree student. */


register_For_Higher_Degree_Course(STUDENT,L1,COURSE_NAME,L2,TIME_SLOT):- generalRequirements(STUDENT),
				                                         is_Singlite(STUDENT),
									 hasCompleted_2yr_Single(L1),
				                                         preRequisitesDone(L1,L2),
				                                         \+slot_booked(TIME_SLOT).

register_For_Higher_Degree_Course(STUDENT,L1,COURSE_NAME,L2,TIME_SLOT):- generalRequirements(STUDENT),
									 is_Dualite(STUDENT),
									 isCourse_HigherDegreeEngg(COURSE_NAME),
									 hasCompleted_2yr_Dual(L1),
									 preRequisitesDone(L1,L2),
									 \+slot_booked(TIME_SLOT).

register_For_Higher_Degree_Course(STUDENT,L1,COURSE_NAME,L2,TIME_SLOT):- generalRequirements(STUDENT),
									 is_Dualite(STUDENT),
									 isCourse_HigherDegreeSci(COURSE_NAME),
									 hasCompleted_3yr_Dual(L1),
									 preRequisitesDone(L1,L2),
									 \+slot_booked(TIME_SLOT).


/***************************************************************************************************************************************************/

/* Clause 3.15 (ACADEMIC REGULATIONS) ----> A student can register for the Discipline (Core or Elective) course of a degree other than student's
own degree(s) if he/she must have completed the prior-preparation of the third year first semester of his/her own programme.*/

register_For_Course(STUDENT,L1,COURSE_NAME,L2,TIME_SLOT):- generalRequirements(STUDENT),
							   isCourses_Completed_Till_Prev_Sem(STUDENT),
							   is_CourseOf_Other_Degree(COURSE_NAME),
					      ((is_Singlite(STUDENT),hasCompleted_2yr_Single(L1));(is_Dualite(STUDENT),hasCompleted_2yr_Dual(L1))),
							   preRequisitesDone(L1,L2),
							   \+slot_booked(TIME_SLOT).


/* Clause 3.14 (ACADEMIC REGULATIONS) ----> A student can register for a CDC if he has completed all named courses in semesters and terms preceding
this set of courses in his/her programme. */

register_For_Course(STUDENT,L1,COURSE_NAME,L2,TIME_SLOT):- generalRequirements(STUDENT),
							   is_CDC(COURSE_NAME,STUDENT),
							   preRequisitesDone(L1,L2),
							   isCourses_Completed_Till_Prev_Sem(STUDENT),
							   \+slot_booked(TIME_SLOT).

/***************************************************************************************************************************************************/


/* VERY IMPORTANT: As soon as you register for a course, add a Predicate 'slot_booked(TIME_SLOT)' in the knowledgebase so that it can check for
    clashes if any one tries to register a course in the same slot. */















