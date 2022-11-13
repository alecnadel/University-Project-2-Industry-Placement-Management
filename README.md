# Project2Group2_S1_2022

## Purpose of the Project

Our teams project has been to create a web app for managing the placement of students taking the Masters of applied computing with prospective industrial hosts. This is currently done by hand (on paper) making it a time-consuming and painful process of manual data entry and assignment. One of the key features of this app revolves around a speed networking event held once every semester for students and industrial hosts participating in the semesters COMP 693 - Industry Project course. Currently after the event, forms are collected from all industrial hosts and students regarding their preferred choice. This data is processed in order to find as many potential placements, for all students if possible. One of the primary goals of this project is to automate the process of selection for all students, ensuring as many students have potential placements. Once the list of potential students for each industrial host has been generated, they will be able to see the student’s CV and email address, allowing them to set up interviews to decide which student they wish to offer their project to. The app has two major uses, the administrator, and students, and a third secondary user, the industrial host. The system will ease the process of coordinating the placement of students with an industrial host for the administrators currently coordinating this work manually.

## Currently Completed Features

* \[IPM-5] login
* \[IPM-6] admin- add company/mentor 
* \[IPM-7] admin-update company details
* \[IPM-9] admin-update student info
* \[IPM-15] student-edit personal info
* \[IPM-40] student-fill in the initial survey form
* \[IPM-41] industry host-fill in networking survey/form including project details
* \[IPM-14] student-submit CV
* \[IPM-10] admin-capture networking event attendance
* \[IPM-57] admin-generate the form that contains the student names and photos, suitability, and        additional notes
* \[IPM-58] admin-generate the form that contains industry hosts, projects, and student preference
* \[IPM-59] admin-generate the student profile report that contains student names and their background
* \[IPM-16] student-view company/mentor details
* \[IPM-47] industry host- view student background before networking
* \[IPM-37] industry host-add students' preference after networking
* \[IPM-20] student-tick a list of interested companies after networking
* \[IPM-12] admin-Generate a report to list the matched students for each industry host
* \[IPM-60] admin-generate a list of matched industry hosts for each student
* \[IPM-19] student-view match companies
* \[IPM-38] industry host-check student status before they call the student for an interview
* \[IPM-39] industry host-view student CV after networking
* \[IPM-11] admin- generate report of a student who has placement
* \[IPM-46] student-update interview(go for an interview for which company and outcome)
* \[IPM-21] student-update placement status
* \[IPM-33] Logout


## Solution 

The industrial placement management system uses MySQL to construct and run the data model shown in figure 1 below.  It contains 15 tables making it relatively complex with the students table having the greatest number of connections to the rest of the model. Followed closely by the industrial host table which comes from the application about using student information to help students be placed with a prospective industrial host. 

### Data Model

 <a href="#"><img src="https://github.com/LUMasterOfAppliedComputing/Project2Group2_S1_2022/blob/916d55b9f667d78918487ae767f277859763f1c2/Readme_images/Database_IPM_EER.png"></a>
 Figure 1: EER diagram for Industry Placement Management (IPM) system

### GUI Design

The GUI design minutes broad strokes are shown in figure 2 and is simple with a utilitarian design having the Lincoln University blue and white colour scheme, utilising forms and tables to enable the various functionalities and interactions within the application, along with background images, log-in interface, Navbar, button group, dropdown list, grid, containers, columns, bootstrap 5 styling, CSS, JavaScript validation, dynamic forms, PDF report templates. This utilitarian design helps streamline the completion of user stories while keeping a consistent look and feel throughout the application.

<a href="#"><img src="https://github.com/LUMasterOfAppliedComputing/Project2Group2_S1_2022/blob/916d55b9f667d78918487ae767f277859763f1c2/Readme_images/GUI_design.png"></a>

Figure 2: general GUI design and layout

The clean design has a blue Navbar across all user interfaces and pages, along with a white background merge with the current Lincoln University branding with the more complex design and implementation of the matching algorithm hidden on the back end of the system. The clear, simple layout of the GUI throughout the app utilising maps features which are simple and intuitive. Each users’ features are split between different sections of the navbar with shutdowns for the separate features, simple if there is only one feature for that section. All the pages consistently use the same sets of blue colours for tables and forms throughout the app to maintain a consistent theme. As discussed above the different user roles have different navbar’s with different functionalities, preventing the students and industrial host from accessing the administration functionality. Each username has a role attached to it which determines when the user logs in and the functionalities that available the user. 

#### Validation and verification:

JavaScript validation is used throughout the forms with input fields that are currently being shown with green text. That outlines any fields with incorrect entered data with red text and outline, verification is implemented using HTML type, within the form HTML files. Alert messages are utilised throughout the app to provide feedback to the user upon submitting forms, photo and CV’s, returning a success story message where appropriate. The above images represent an example of the table design and form layout throughout the app. The alert message shows green, yellow, and red for different outcomes. Success messages are green meaning the information entered for that input is correct, yellow means there is no input form or field when a file input field is to upload a photo or CV is left blank. Error messages are red and show where the inputs are incorrectly formatted or one of the required fields is left blank. Form validations utilise the accommodation of JavaScript and Bootstrap 5. Some of the report tables used to generate these along with their HTML styling dynamic, only generated PDF files for the admin to email or print for hosts and students attending the speed networking event.


### PythonAnywhere link

PythonAnywhere link: <a href="sophiazhu469.pythonanywhere.com">sophiazhu469.pythonanywhere.com</a>
Test log-in data:

Student - sophia, wade

Host - testhost, nufarm

Admin - pat

Password for all the same: password1

## Improved Industry Placement Management Web App

1.	Preparing it for regular use (every semester)

*	Added adminsemester table which the current the latest year and semester are selected as the current selection period throughout the app from the administrators point of view.
*	A form for changing the current year and semester of the administrator was planned but ultimately scrapped for other important functionality to be completed (inputs disabled).
*	Currently the administrator can go to the semester have and will be taken to a form where they can press a button that will update the adminsemester table with the new year and semester for the upcoming matching period.

2.	Company can host more than 1 project

*	Added the ability for the matching algorithm to sum up the potential placements among all projects for the industry host.
*	Have also added an in-depth form for editing and adding new projects for a particular industrial host from the companies tab. (Currently it is not possible to edit tech person details so I have made it so if you enter a currently existing tech person their phone number and email are read-only, it might also be a reasonable idea to add restrictions for uniqueness to the tech person’s phone number and email address not currently restricted).
*	This new form can be found in the actions drop-down list in the companies tables there are now 2 companies tables one for companies attending the speed networking event and one that contains all companies in the database.

3.	Providing a way for the administrator to key in information for the company after the speed networking. 

*	Have added in a button for the industrial host report which will take the administrator to a form where they can edits the project descriptions of company current list of projects.

4.	Read in the Excel file of the survey (for industry hosts) and insert this information in the database.

*	Have added a link under the companies section ‘import industry host survey form from Excel’ in which one can upload an Excel file and have the answers imported into the database.
*	The company names must be the same between all duplicate entries for these duplicates to correctly updated these entries from the survey file provided there was one example where AgResearch ltd and AgResearch caused problems with this functionality with the new data from the duplicate record was not processed, the original data was however retained undamaged. The organisation name comparison is not case sensitive but cannot process a search for sub string eliminating limited, ltd or (NZ) Limited.
*	Also, the question titles need to be the same as those provided in the example I was given by Richard or when these titles are changed the code needs to be altered to adjust to the new set of titles to work appropriately.
*	The project tech ranking question was processed using the full list that was comma separated based on the assumption that the first entry is the highest ranked and that the last entry is the lowest ranked and is split into a list based on python split(“,”) method.
*	any new technologies are added to the technology table and given a technology Id. (This will probably add these technologies to the student tech ranking question for the student survey form)
*	to successfully add a new company to the industry host table the survey must have at least a name for the admin and an email address for the admin there phone number is optional and is now nulliable after rerunning database setup file “IMP.sql”.
*	The tech person needs the same minimum number of inputs as the company admin to be inserted into the database.
*	For now, the companies username (company name which spaces replace with underscores and all uppercases characters converted to lowercase) and password (default equals: password1) are set default.
*	Once the file has been read and from the form submission is converted into a pandas dataframe which has been added to the list requirements for running the app.
*	When the Excel file is updated, the system should be able to simply run the whole import process again updating the required fields where necessary.
*	This importing process is probably still currently a bit delicate and sensitive to changes in the input type and questions and how the data is formatted. (Import processing based on the “Industry survey.xlsx” file sent by Richard)

5.	Adding a registration interface for students to add their information. 

*	Have added a student registration form allowing students to set up a new account with a username and password.
*	Have updated the password system to use a hash system with SHA2(input,256) to anonymized password entries in the users database table.

6.	Improve the matching algorithm to accommodate multiple project per industry host.

*	As the matching algorithm uses the selections of both the students and companies it is in no way directly linked to the projects the companies are proposing for next semester so the most important thing for the matching algorithm’s point of view is to know how many places are available in total from all projects that a company is offering next semester I have now altered the sequel query to sum the number of potential placements between all projects taking place in the upcoming semester by each industry host. Otherwise, the number of projects or project details do not in any other way influence the algorithm.

7.	Miscellaneous extra features (some of which have been mentioned above).

*	Have allowed the admin to edit the project descriptions by going to the industrial host report and pressing the edit project description button. 
*	Added attending the speed networking event company list “attending industry host list”
*	add the ability to toggle industry host attendance from the actions drop-down list of either of the industry host lists.
*	It also added a matching table that visualises the results of the speed networking event and the matching algorithm and student names along the top and industrial hosts along the left side of  the table. Boxes indicating a placement are coloured yellow with a 3 inside, selected placements from the matching algorithm are coloured green and labelled 2, blue boxes are matches which were not selected by the matching algorithm but could have been and any boxes that remain grey/white mean that one of the other of the student or host did not select the other.

### Features for future development:

*	Editing tech person details in the app.
*	Being able to delete projects, potentially from the project editing and updating form.
*	Being able to view a list of companies who have projects for the upcoming semester and not just the companies who are attending the networking event.

