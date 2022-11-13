from itertools import groupby
from random import randint

    









###########################################################################################################################3 



sID = [10,11,12,13,14,15,16,17,18,19] # 10, 14, 11, 13, 15, 12
cID = [20,21,22,23,24,25,26,27,28,29] # 29,20,22,24,25
# intial_matches = [(10,29,2), # select_student_matches 1
#                 (14,29,1),
#                 (11,20,1),(11,22,1),(11,29,1), # select_student_matches 2
#                 (12,22,1),(12,20,2),(12,20,2), #select_student_matches 3, select_student_matches 4
#                 (13,24,2),(13,29,2),(13,20,2), # select_student_matches 5 select_student_matches 7 
#                 (15,25,2),(15,29,2),(15,20,1)  # select_student_matches 5 select_student_matches 6

#                 # (16,),(),(),(),
#                 # (17),(),(),(),
#                 # (18),(),(),(),
#                 # (19),(
#                 # 
#                 # ()),(),(),(19,28,2) # company_extra_matches 1
#                 ]
intial_matches = [(10,20,1),(10,21,2), # select_student_matches 1
                  (11,20,1),(11,21,1),(11,21,1), # select_student_matches 2
                  (12,22,2),(12,23,1),(12,24,2), # select_student_matches 3, select_student_matches 4
                  (13,22,1),(13,23,2),(13,24,2), # select_student_matches 3, select_student_matches 4
                  (14,24,2),(14,23,1),(14,22,2), # select_student_matches 5, select_student_matches 6
                  (15,24,2),(15,21,2),(15,20,2)  # select_student_matches 5, select_student_matches 7
                ] # complete Companies 20,21,22,23,24,25

expected_matches = [(10,20,1),(10,21,2),
                    (11,20,1),(11,21,1),
                    (12,23,1),(12,22,2),
                    (13,22,1),(13,23,2),
                    (14,24,2),(14,23,1),
                    (15,24,2),(15,21,2)]   

match_list =[] # industry_ids, student_ids, company response
matched_students_ids = [] 
matched_company_ids = [(20,[0],1),(21,[0],1),(22,[0],1),(23,[0],1),(24,[0],1),(25,[0],1),(26,[0],1),
                       (27,[0],1),(28,[0],1),(29,[0],1)] 

#Loops over each student once starting with the students with 
#the least number of potential placements
# for i in range(len(list(groupby(intial_matches, lambda x: x[0])))):

#     selected,matched_students_ids = select_student_id(intial_matches,matched_students_ids)

#     match_list,intial_matches = select_student_matches(selected,match_list,intial_matches,matched_company_ids,2)
# print(match_list)
print("match_list == expected_matches",match_list == expected_matches)

matched_company_ids2 = [(20,[0],1),(21,[0],1),(22,[0],1),(23,[0],1),(24,[0],1),(25,[0],1),(26,[0],1),
                       (27,[0],1),(28,[0],1),(29,[0],1)] 
match_list2 = []
# intial_matches2 =[(11,21,1),(12,21,1), # company_extra_matches 1
#                  (11,22,1),(12,22,1),(13,22,1), # company_extra_matches 2
#                  (11,23,2),(12,23,2),(13,23,1), # company_extra_matches 3
#                  (11,24,2),(12,24,2), # company_extra_matches 4
#                  (11,25,2), # company_extra_matches 5
#                  (11,26,2),(12,24,3),(13,23,3)
#                 ]
intial_matches2 =[(10,20,1),(11,20,1), # company_extra_matches 1
                  (10,21,1),(11,21,1),(12,21,2), # company_extra_matches 2
                  (10,22,1),(11,22,2),(12,22,2), # company_extra_matches 3,company_extra_matches 4
                  (10,23,1),(11,23,2),(12,23,3), # company_extra_matches 3, company_extra_matches 5
                  (10,24,2),(11,24,2),(12,24,2), # company_extra_matches 4, company_extra_matches 4
                  (10,25,2),(11,25,2),(12,25,3) # company_extra_matches 5, company_extra_matches 5
                  ]


# data = list(groupby(intial_matches2, lambda x: x[1]))
# print("company_extra_matches ",data)
# for id,data in groupby(intial_matches2, lambda x: x[1]):
#     data2 = list(data)
#     print(data2)

# expected_matches2 = [(10,20,1),(11,20,1),
#                     (10,21,1),(11,21,1),
#                     (10,22,1),(11,22,2),
#                     (10,23,1),(11,23,2),
#                     (10,24,2),(11,24,2),
#                     (10,25,2),(11,25,2)
#                     ]


# match_list2,intial_matches2 = company_extra_matches(match_list2,intial_matches2,matched_company_ids2,2)

# print("match_list2 == expected_matches2",match_list2 == expected_matches2)