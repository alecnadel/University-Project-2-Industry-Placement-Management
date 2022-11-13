
from click import command
from models.db import get_cursor
from models.services import PrjectForNextSemester,AdminCurrentSemester
from datetime import date
from itertools import groupby
from random import randint








def select_student_id(intial_matches,matched_students_ids):
    """This function selects the students with the least number of potential 
        placements selecting a student at random if there are multiple students with 
        the same lowest number of potential placements"""
    minimun_count = len(intial_matches)
    students_options = []

    intial_matches.sort(key=lambda x: x[0])
    for student_id, match in groupby(intial_matches, lambda x: x[0]):
        match = list(match)
        length = len(match)
        if (minimun_count > length) and (not student_id in matched_students_ids):
            minimun_count= length
            students_options = []
            students_options.append((student_id,match))
        elif minimun_count == length:
            minimun_count= length
            students_options.append((student_id,match))
    
    if len(students_options) != 0:
        i = randint(0,len(students_options)-1)
        student = students_options[i]
        matched_students_ids.append(students_options[i][0])
    else:
        student = None
    return student, matched_students_ids


def check_company_selecton_limit(potential_match,company_selection_counts,n):
    """Checks if there potential matched company as reached its selection limit 
        which is the number of project placements times n (selection option number)"""
    # company_selection_counts list of tuples with campany_id, current_selection_count, placement_count
    matched_company = [match for match in company_selection_counts if potential_match[1]==match[0]][0]
    if  matched_company[1][0] < matched_company[2]*n: # matched_company = (HostId,[currentSelectionCount],TotalProjectPlacementCount)
        return True
    return False


def update_company_selecton_matches(potential_match,company_selection_counts):
    """updates the potential company matches count of a company"""
    matched_company = [match for match in company_selection_counts if potential_match[1]==match[0]]
    if len(matched_company) > 0:
        matched_company = matched_company[0]
        for matched_company in company_selection_counts:
            if potential_match[1]== matched_company[0]:
                matched_company[1][0] +=1
    return company_selection_counts

# def check_selection_limit(company_selection_counts,n):
#     """function check if all companies have all there selection options"""
#     counted_needed = len(company_selection_counts)
#     count = 0
#     for selection_count in company_selection_counts:
#         if selection_count[1] >= selection_count[2]*n:
#             count += 1
#     if counted_needed == count:
#         return True
#     return False

def select_random_match(match_list,intial_matches,matched_company_ids,reponse_matches):
    """The functions selects a random match to add to the selected matches list"""
    j = randint(0,len(reponse_matches)-1)
    match_list.append(reponse_matches[j])
    matched_company_ids = update_company_selecton_matches(reponse_matches[j],matched_company_ids)
    intial_matches.remove(reponse_matches[j]) 
    reponse_matches.remove(reponse_matches[j])
    return match_list,intial_matches,reponse_matches,matched_company_ids

def select_student_matchesOLD(selected,match_list,intial_matches,matched_company_ids,n):
    """This function if possible assigns the target minimum number of matches (n=3) for 
        the student that is being processed (selected)."""
    
    # Checks if the student is less than n matches
    if len(selected[1]) <= n:
        # Assigns all available matches
        for match in selected[1]:
            match_list.append(match)
            matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
            intial_matches.remove(match)
            print("select_student_matches 1")

            
    else:
        # Splits the potential matches up by company response (yes/maybe) as well 
        # as by whether the company is already gone more potential selections than needed.
        yes_matches = []
        maybe_matches = []
        yes_over_cap = []
        maybe_over_cap = []
        for match in selected[1]:
            if check_company_selecton_limit(match,matched_company_ids,n): 
                if match[2] == 1:
                    yes_matches.append(match)
                elif match[2] == 2:
                    maybe_matches.append(match)
            else:
                if match[2] == 1:
                    yes_over_cap.append(match)
                else:
                    maybe_over_cap.append(match)

        # Checks if there are less matches than the minimum selection limit
        if len(yes_matches) >= n:
            # Randomly selects the required number of potential matches
            for i in range(0,n):
                (match_list,
                intial_matches,
                yes_matches,
                matched_company_ids) = select_random_match(match_list,
                                                            intial_matches,
                                                            matched_company_ids,yes_matches)
            print("select_student_matches 2")
 
        else:
            # Assigns all available yes matches
            for match in yes_matches:
                match_list.append(match)
                matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                intial_matches.remove(match) 
            print("select_student_matches 3")

           
            
            # Checks placements are still required and then checks 
            # if the number of maybe responses exceeds the number of required selections left
            if (n - len(yes_matches) > 0) and ((n - len(yes_matches)) < len(maybe_matches)):
                for i in range(0,n - len(yes_matches)):
                    
                    (match_list,
                    intial_matches,
                    yes_matches,
                    matched_company_ids) = select_random_match(match_list,
                                                                intial_matches,
                                                                matched_company_ids,maybe_matches)
                print("select_student_matches 4")

            # Checking that matches are still required after selecting all maybe responses     
            elif n - len(yes_matches) - len(maybe_matches) > 0:
                # Selects all available maybe responses
                for match in maybe_matches:
                    match_list.append(match)
                    matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                    intial_matches.remove(match)
                print("select_student_matches 5")

                
                # Selecting available over cap matches if necessary.
                for i in range(0,n - len(yes_matches) - len(maybe_matches)):

                    if len(yes_over_cap) > 0:
                        
                        
                        (match_list,
                        intial_matches,
                        yes_matches,
                        matched_company_ids) = select_random_match(match_list,
                                                                    intial_matches,
                                                                    matched_company_ids,yes_over_cap)
                        print("select_student_matches 6")
                        continue

                    elif len(maybe_over_cap) > 0:
                        

                        (match_list,
                        intial_matches,
                        yes_matches,
                        matched_company_ids) = select_random_match(match_list,
                                                                    intial_matches,
                                                                    matched_company_ids,maybe_over_cap)
                        print("select_student_matches 7")
                    else:
                        print("not enough matches to complete matching  limit")
                        break

    return match_list,intial_matches

def select_student_matches(selected,match_list,intial_matches,matched_company_ids,n):
    """This function if possible assigns the target minimum number of matches (n=3) for 
        the student that is being processed (selected)."""
    
    # Checks if the student is less than n matches
    if selected != None:
        if len(selected[1]) <= n:
            # Assigns all available matches
            for match in selected[1]:
                match_list.append(match)
                matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                intial_matches.remove(match)
            

                
        else:
            # Splits the potential matches up by company response (yes/maybe) as well 
            # as by whether the company is already gone more potential selections than needed.
            yes_matches = []
            maybe_matches = []
            yes_over_cap = []
            maybe_over_cap = []
            for match in selected[1]:
                if check_company_selecton_limit(match,matched_company_ids,n): 
                    if match[2] == 1:
                        yes_matches.append(match)
                    elif match[2] == 2:
                        maybe_matches.append(match)
                else:
                    if match[2] == 1:
                        yes_over_cap.append(match)
                    else:
                        maybe_over_cap.append(match)

            # Checks if there are less matches than the minimum selection limit
            if len(yes_matches) >= n:
                # Randomly selects the required number of potential matches
                for i in range(0,n):
                    (match_list,
                    intial_matches,
                    yes_matches,
                    matched_company_ids) = select_random_match(match_list,
                                                                intial_matches,
                                                                matched_company_ids,yes_matches)
                   
    
            else:
                # Assigns all available yes matches
                for match in yes_matches:
                    match_list.append(match)
                    matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                    intial_matches.remove(match) 
                    
            
                
                # Checks placements are still required and then checks 
                # if the number of maybe responses exceeds the number of required selections left
                
                if (n - len(yes_matches) > 0) and ((n - len(yes_matches)) < len(maybe_matches)):
                    for i in range(0,n - len(yes_matches)):
                        
                        (match_list,
                        intial_matches,
                        maybe_matches,
                        matched_company_ids) = select_random_match(match_list,
                                                                    intial_matches,
                                                                    matched_company_ids,maybe_matches)
                        

                # Checking that matches are still required after selecting all maybe responses     
                elif n - len(yes_matches) > 0: # - len(maybe_matches)
                    # Selects all available maybe responses
                    for match in maybe_matches:
                        match_list.append(match)
                        matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                        intial_matches.remove(match)
                       
                    
                    # Selecting available over cap matches if necessary.
                    for i in range(0,n - len(yes_matches) - len(maybe_matches)):

                        if len(yes_over_cap) > 0:
                            
                            
                            (match_list,
                            intial_matches,
                            yes_over_cap,
                            matched_company_ids) = select_random_match(match_list,
                                                                        intial_matches,
                                                                        matched_company_ids,yes_over_cap)
                            

                        elif len(maybe_over_cap) > 0:
                            

                            (match_list,
                            intial_matches,
                            maybe_over_cap,
                            matched_company_ids) = select_random_match(match_list,
                                                                        intial_matches,
                                                                        matched_company_ids,maybe_over_cap)
                            
                        else:
                            print("not enough matches to complete matching  limit")
                            break

    return match_list,intial_matches

def company_selection_number(company_id,matched_company_ids,n):
    """returns the selection option limit for a company based on 
        number of potential placements."""
    for selection in matched_company_ids:
        if selection[0] == company_id:
            return selection[2]*n -  selection[1][0]
    return n

def company_extra_matchesOLD(match_list,intial_matches,matched_company_ids,n):
    """Finds if possible additional potential placements for Industry hosts that have not yet 
        reach their full complement of potential placements based on the number of students 
        their willing to place."""

    # Loops over all industry hosts with potential matches
    intial_matches.sort(key=lambda x: x[1])
    for company_id, matches in groupby(intial_matches, lambda x: x[1]):
        matches = list(matches)
        # Checks the industrial host has not yet reached its match limit
        if check_company_selecton_limit(matches[0],matched_company_ids,n):
            # If total number of remaining matches is less than remaining number of 
            # potential placements at to be added.
            if len(matches) <= company_selection_number(company_id,matched_company_ids,n):
                for match in matches:
                    match_list.append(match)
                    matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                    intial_matches.remove(match)
                    print("company_extra_matches 1")
                
                      
            else:
                # Splits the remaining potential matches into yes and maybe responses.
                yes_matches = []
                maybe_matches = []
                for match in matches:
                    if check_company_selecton_limit(match,matched_company_ids,n): 
                        if match[2] == 1:
                            yes_matches.append(match)
                        elif match[2] == 2:
                            maybe_matches.append(match)
                
                # Check if the number of yes matches is greater than the number of matches 
                # remaining to be filled.
                if len(yes_matches) >= company_selection_number(company_id,matched_company_ids,n):
                    for i in range(0,n):
                     
                        if check_company_selecton_limit(matches[0],matched_company_ids,n):
                            (match_list,
                            intial_matches,
                            yes_matches,
                            matched_company_ids) = select_random_match(match_list,
                                                                        intial_matches,
                                                                        matched_company_ids,yes_matches)
                    print("company_extra_matches 2")
                    
                   
    
                else:
                    # Add potential matches with yes responses.
                    for match in yes_matches:
                        if check_company_selecton_limit(matches[0],matched_company_ids,n):
                            match_list.append(match)
                            matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                            intial_matches.remove(match) 
                    print("company_extra_matches 3")
                    
                    # Checks that additional potential placements are still required and if the number is less 
                    # than the net remaining in the maybe_matches list
                    options_limit = company_selection_number(company_id,matched_company_ids,n)
                    if (options_limit > 0) and (options_limit < len(maybe_matches)):
                        for i in range(0,n - len(yes_matches)):
  
                            if check_company_selecton_limit(matches[0],matched_company_ids,n): 
                                (match_list,
                                intial_matches,
                                maybe_matches,
                                matched_company_ids) = select_random_match(match_list,
                                                                            intial_matches,
                                                                            matched_company_ids,maybe_matches)
                        print("company_extra_matches 4")
                    else:
                        for match in maybe_matches:
                            if check_company_selecton_limit(matches[0],matched_company_ids,n):
                                match_list.append(match)
                                matched_company_ids = update_company_selecton_matches(match,matched_company_ids)
                                intial_matches.remove(match) 
                        print("company_extra_matches 5")
    return match_list,intial_matches


def company_extra_matches(match_list,intial_matches,matched_company_ids,n):
    """Finds if possible additional potential placements for Industry hosts that have not yet 
        reach their full complement of potential placements based on the number of students 
        their willing to place."""

    # Loops over all industry hosts with potential matches
    intial_matches.sort(key=lambda x: x[1])
    companies = []
    for company_id, matches in groupby(intial_matches, lambda x: x[1]):
        matches = list(matches)
        companies.append((company_id,matches))
        martchone =  matches[0]

    for  matches2 in companies:   
        company_id = matches2[0]
        # Checks the industrial host has not yet reached its match limit
        if check_company_selecton_limit(matches2[1][0],matched_company_ids,n):
            # If total number of remaining matches is less than remaining number of 
            # potential placements at to be added.
            if len(matches2[1]) <= company_selection_number(company_id,matched_company_ids,n):
                for i in range(len(matches2[1])):
                    
                    match_list.append(matches2[1][0])
                    matched_company_ids = update_company_selecton_matches(matches2[1][0],matched_company_ids)
                    intial_matches.remove(matches2[1][0])
                    matches2[1].remove(matches2[1][0])
                    
                      
            else:
                # Splits the remaining potential matches into yes and maybe responses.
                yes_matches = []
                maybe_matches = []
                for match1 in matches2[1]:
                    # print("match 1",match)
                    # print("matched_company_ids 1",matched_company_ids),
                    if check_company_selecton_limit(match1,matched_company_ids,n): 
                        if match1[2] == 1:
                            yes_matches.append(match1)
                        elif match1[2] == 2:
                            maybe_matches.append(match1)
                

                # Check if the number of yes matches is greater than the number of matches 
                # remaining to be filled.
                if len(yes_matches) >= company_selection_number(company_id,matched_company_ids,n):
                    for i in range(0,n):
                     
                        if check_company_selecton_limit(martchone,matched_company_ids,n):
                            (match_list,
                            intial_matches,
                            yes_matches,
                            matched_company_ids) = select_random_match(match_list,
                                                                        intial_matches,
                                                                        matched_company_ids,yes_matches)
                    
                   
    
                else:
                    # Add potential matches with yes responses.
                    for match2 in yes_matches:
                        if check_company_selecton_limit(matches2[1][0],matched_company_ids,n):
                            match_list.append(match2)
                            matched_company_ids = update_company_selecton_matches(match2,matched_company_ids)
                            intial_matches.remove(match2) 

                            
                    
                    # Checks that additional potential placements are still required and if the number is less 
                    # than the net remaining in the maybe_matches list
                    options_limit = company_selection_number(company_id,matched_company_ids,n)
                    if (options_limit > 0) and (options_limit < len(maybe_matches)):
                        
                        for i in range(0,n - len(yes_matches)):
  
                            if check_company_selecton_limit(matches2[1][0],matched_company_ids,n): 
                                (match_list,
                                intial_matches,
                                maybe_matches,
                                matched_company_ids) = select_random_match(match_list,
                                                                            intial_matches,
                                                                            matched_company_ids,maybe_matches)
                                 

                    else:
                        for match3 in maybe_matches:
                            if check_company_selecton_limit(matches2[1][0],matched_company_ids,n):
                                match_list.append(match3)
                                matched_company_ids = update_company_selecton_matches(match3,matched_company_ids)
                                intial_matches.remove(match3) 
    return match_list,intial_matches


def company_selection_limits():
    """This function returns a list of tuples of the company_ids, selection_count 
        and project_placements"""
    # current year and semester defined
    
    Year, Semester = PrjectForNextSemester()

    # Extracts a list of industrial hosts for the project for the upcoming semester.
    cur = get_cursor()
    cur.execute("SELECT Industry_host_id,sum(potential_placements) potential_placements \
                        FROM projects \
                            WHERE  year=%s AND semester=%s \
                                        GROUP BY Industry_host_id;",(Year,Semester))
    company_project_selections = cur.fetchall()

    # Construct a list of tuple containing industry host ID list with the current 
    # count of potential selections and number of placements for their project.
    company_selection_counts = []
    for id,placements in company_project_selections:
        company_selection_counts.append((id,[0],placements))

    return company_selection_counts


def Matching_algorithm(n=3):
    """function runs the algorithm that creates the list 
       student plasements for each industry host (n is the minimum goal
       number of option for each Company)"""

    # Finding the current year and semester and setting up the cursor
    
    Year, Semester = AdminCurrentSemester()

    cur = get_cursor()


    #Query to find all potential matches between industry hosts and students
    cur.execute("SELECT SS.students_id, CS.Industry_host_id, CS.responses \
                FROM student_selections SS \
                    INNER JOIN company_selections CS \
                        ON SS.Students_id = CS.Students_id AND CS.Industry_host_id = SS.Industry_host_id \
                        GROUP BY Industry_host_id,Students_id,responses \
                        HAVING Industry_host_id in (SELECT Industry_host_id FROM host_attendance WHERE Year=%s AND Semester=%s) \
                        ORDER BY Students_id ASC,responses ASC;",(Year,Semester))
    intial_matches = cur.fetchall()

    # Initialised necessary list variables for matching algorithm
    match_list =[] # industry_ids, student_ids, company response
    matched_students_ids = [] 
    matched_company_ids = company_selection_limits() 

    #Loops over each student once starting with the students with 
    #the least number of potential placements
    for i in range(len(list(groupby(intial_matches, lambda x: x[0])))):

        selected,matched_students_ids = select_student_id(intial_matches,matched_students_ids)

        match_list,intial_matches = select_student_matches(selected,match_list,intial_matches,matched_company_ids,n)

    #Finds if possible any additional for industry hosts
    match_list,intial_matches = company_extra_matches(match_list,intial_matches,matched_company_ids,n)

    # Takes the list of matches found and converts it into 
    # a string that can be inserted into the query to update 
    # the selected rows in the Company_selections table.
    match_list.sort(key=lambda x: x[1])
    match_list = tuple(match_list)
    selection = "("
    for match in match_list:
        selection += "('{}','{}','{}'),".format(match[0],match[1],match[2])
    selection = selection.rstrip(",")
    selection += ')'    
    command = "UPDATE company_selections CS \
                SET match_confirmation = 1  \
                WHERE (CS.Students_id,CS.Industry_host_id,CS.responses) IN {};".format(selection)
    cur.execute(command)
    return match_list

def unmatch_users():
    """Finds the list of users (industry host or student) 
        that currently have no available selections to select from."""
    # Finds current year and semester  
    cur = get_cursor()
    
    year, semester = AdminCurrentSemester()

    #Extract a list of all students and industrial hosts which have potential matches.
    cur.execute("SELECT CS.Students_id, CS.Industry_host_id  FROM company_selections CS \
                INNER JOIN students S \
                    ON CS.Students_id = S.student_id \
                INNER JOIN host_attendance HA \
                    ON HA.Industry_host_id = CS.Industry_host_id \
                WHERE CS.match_confirmation=1 AND (S.year=%s AND S.semester=%s) AND attendance=1\
                  AND (HA.Year=%s AND HA.Semester=%s);",(year,semester,year,semester,))
    selection_list = cur.fetchall()
    student_id_matches = [x[0] for x in selection_list]
    company_id_matches = [x[1] for x in selection_list]

    #Extracts are lists of student ideas and first and last names 
    # who attended the networking event.
    cur.execute("SELECT student_id,first_name,last_name \
                    FROM students WHERE year=%s AND semester=%s AND attendance=1",(year,semester))
    students = cur.fetchall()
    missing_student = []

    #Create a list of students we have no potential placements.
    for student in students:
        if not student[0] in student_id_matches:
            missing_student.append(student)

    #Finds a list of industry hosts who attended the networking event.
    cur.execute("SELECT HA.Industry_host_id,IH.organization_name \
                    FROM host_attendance HA \
                        INNER JOIN industry_host IH\
                            ON IH.Industry_host_id = HA.Industry_host_id \
                    WHERE HA.Year=%s AND HA.Semester=%s",(year,semester))
    companies = cur.fetchall()
    missing_company = []
    
    #Finds a list of industry hosts who have no students to place.
    for company in companies:
        if not company[0] in company_id_matches:
            missing_company.append(company)
    return missing_student,missing_company

def Match_Report_formating(Selections):
    """This functionary formats the results of the matching algorithm
        For the industrial host matching report removing the repeated 
        organisation names from the tuple returned."""
    company_name=""
    restructured_Selections = []


    # Reformat the potential selections by removing the repeated organisation names.
    for selection in Selections:
        if selection[0] != company_name:
            restructured_Selections.append(selection)
            company_name = selection[0]
        else:
            restructured_Selections.append(("",selection[1],selection[2]))
    
    return restructured_Selections

def industry_host_selection(match_list):
    """This function takes in the the finalised set of potential matches 
        for the industrial host matching report when it is posted for the first time
        and then uses them to extract the organisation names and student names"""
    selection = "("
    for match in match_list:
        selection += "('{}','{}','{}'),".format(match[0],match[1],match[2])
    selection = selection.rstrip(",")
    selection += ')'
    command = "SELECT IH.organization_name,S.first_name,S.last_name,IH.Industry_host_id FROM company_selections CS \
                INNER JOIN industry_host IH \
                    ON CS.Industry_host_id = IH.Industry_host_id \
                INNER JOIN students S \
                    ON CS.Students_id = S.student_id \
                WHERE (CS.Students_id,CS.Industry_host_id,CS.responses) IN {} \
                ORDER BY IH.Industry_host_id;".format(selection) # S.first_name,S.last_name
    cur = get_cursor()
    cur.execute(command)
    Selections = cur.fetchall()
    Selections = Match_Report_formating(Selections)
    missing_student,missing_company = unmatch_users()
    return Selections,missing_student,missing_company


def industry_host_selected():
    """This function extracts and re-formats the potential matches found 
        for the industry host matching report on GET after the match algorithm 
        has been executed, for the current year and semester."""

    # current year and semester defined
    
    year, semester = AdminCurrentSemester()
    # Extracts list of all industrial host and student's potential placements 
    # that are still in the process of selecting their placements.
    cur = get_cursor()
    cur.execute("SELECT IH.organization_name,S.first_name,S.last_name,IH.Industry_host_id \
	                FROM company_selections CS \
                        INNER JOIN industry_host IH \
                            ON CS.Industry_host_id = IH.Industry_host_id \
                        INNER JOIN students S \
                            ON S.student_id = CS.Students_id \
                        INNER JOIN projects R \
                            ON R.Industry_host_id = IH.Industry_host_id \
                        WHERE CS.match_confirmation=1 AND S.year=%s AND S.semester=%s \
                            AND NOT IH.Industry_host_id IN (SELECT placed.Industry_host_id FROM (SELECT P.Industry_host_id,P.potential_placements,P.projects_id, count(*) placed FROM projects P \
															INNER JOIN placement PL \
																ON PL.Projects_id = P.Projects_id \
																group by projects_id \
																	Having P.potential_placements <= placed) AS placed) \
                    AND (S.student_id IN (SELECT student_id FROM students WHERE NOT student_id IN (SELECT students_id FROM placement GROUP BY students_id))) \
                    ORDER BY IH.organization_name;",(year,semester,))
    Selections = cur.fetchall()

    # Re-formats and then identifies all industry hosts and students 
    # without potential placements
    Selections = Match_Report_formating(Selections)
    missing_student,missing_company = unmatch_users()
    return Selections,missing_student,missing_company if len(Selections) > 0 else None


def Match_Report_student_formating(Matches):
    """This function reformats the potential placements for the student matching report 
        removing the repeated student names, for this current year and semester."""
    
    student_name=""
    restructured_Selections = []

    # From this list of potential matches students have their potential placements reformatted 
    # so their name only appears once. 
    for selection in Matches:
        if selection[1] + selection[2] != student_name:
            restructured_Selections.append(selection)
            student_name = selection[1] + selection[2]
        else:
            restructured_Selections.append((selection[0],"",""))
    
    return restructured_Selections

def student_host_selected():
    """This function extracts and then reformats the selected potential placements 
        for the student matching report, for the current year and semester."""
    
    # current year and semester defined
    year,semester = AdminCurrentSemester()
    # Extracts the list of students for this year and semester still looking for a placement.
    cur = get_cursor()
    cur.execute("SELECT IH.organization_name,S.first_name,S.last_name,IH.Industry_host_id FROM company_selections CS \
                INNER JOIN industry_host IH \
                    ON CS.Industry_host_id = IH.Industry_host_id \
                INNER JOIN students S \
                    ON CS.Students_id = S.student_id \
                WHERE CS.match_confirmation=1 AND S.year=%s AND S.semester=%s \
                    AND NOT IH.Industry_host_id IN (SELECT placed.Industry_host_id FROM (SELECT P.Industry_host_id,P.potential_placements,P.projects_id, count(*) placed FROM projects P \
															INNER JOIN placement PL \
																ON PL.Projects_id = P.Projects_id \
																group by projects_id \
																	Having P.potential_placements <= placed) AS placed) \
                    AND (S.student_id IN (SELECT student_id FROM students WHERE NOT student_id IN (SELECT students_id FROM placement GROUP BY students_id))) \
                        ORDER BY S.first_name;",(year,semester,))
    Matches = cur.fetchall()
    Matches = Match_Report_student_formating(Matches)
    return Matches if len(Matches) > 0 else None    










