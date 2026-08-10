Student Grade Calculator

Team Lead

Danylo

Project Description

The Student Grade Calculator is a Bash shell scripting application designed to help students calculate and 
understand their academic performance.

The program allows users to enter marks for assignments, quizzes, tests, mid-term examinations, and final 
examinations. Each assessment is assigned a percentage weight, and the program calculates the student's weighted 
final course grade.

The application accepts both numerical grades and letter grades. It validates user input, calculates the final 
grade, displays the corresponding letter grade, and provides a target-grade calculator to determine the score 
required on the final examination to achieve a desired course grade.

The application uses a menu-driven command-line interface and allows users to perform multiple operations 
without restarting the program.


The objectives of this project are:

1. Create a functional Bash shell scripting application.
2. Allow students to enter grades for multiple assessments.
3. Accept numerical and letter-grade input.
4. Accept assessment weights.
5. Validate marks between 0 and 100.
6. Validate assessment weights.
7. Ensure all assessment weights total 100%.
8. Calculate a weighted final course grade.
9. Display a corresponding letter grade.
10. Calculate the score required to achieve a target grade.
11. Provide clear error messages.
12. Allow users to reset entered data.
13. Save grade information to a text file.
14. Provide a simple command-line user interface.
15. Demonstrate Bash programming concepts covered in CPAN 133.


The program includes:

* Interactive menu
* Student name input
* Assignment grade input
* Quiz grade input
* Test grade input
* Mid-term grade input
* Final exam grade input
* Numerical grade input
* Letter grade input
* Assessment weight input
* Input validation
* Weighted-average calculation
* Letter-grade calculation
* Target-grade calculator
* Reset functionality
* Help menu
* Error handling
* Data storage
* Multiple calculations
* Exit message

---

Menu

The program provides the following options:
1. Enter Student Grade
2. Calculate Final Grade
3. Target Grade Calculator
4. View Letter Grade
5. Reset Data
6. Help
7. Exit

---


The application uses the following grading scale:

| Numerical Grade | Letter |
| --------------- | ------ |
| 80-100          | A      |
| 70-79           | B      |
| 60-69           | C      |
| 50-59           | D      |
| 0-49            | F      |

---
Letter Grade Conversion

The program can accept letter grades as input.

Examples include:

A
A-
B+
B
B-
C+
C
C-
D
F


Letter grades are converted to approximate numerical values before the weighted calculation is performed.

---


The final grade is calculated using:

Final Grade =
Assignment Mark × Assignment Weight
+
Quiz Mark × Quiz Weight
+
Test Mark × Test Weight
+
Mid-term Mark × Mid-term Weight
+
Final Exam Mark × Final Exam Weight

The percentage weights are converted into decimal values during the calculation.

For example:

Assignment = 85%, Weight = 20%
Quiz       = 90%, Weight = 10%
Test       = 80%, Weight = 20%
Mid-term   = 75%, Weight = 20%
Final Exam = 88%, Weight = 30%

The resulting final grade is:

83.40%

This corresponds to:

A

---
Target Grade Calculator

The target-grade calculator allows a student to enter a desired final course grade.

The program uses the grades already entered for the assignment, quiz, test, and mid-term and calculates the 
score required on the final examination.

For example:

Target Grade: 90%
Required Final Exam Score: 92.50%

If the required score is greater than 100%, the program informs the user that the target is not achievable with 
the remaining assessment.

---


The program checks for invalid information.

Examples include:

* Negative grades
* Grades above 100
* Invalid letter grades
* Invalid assessment weights
* Assessment weights that do not total 100%
* Empty student names
* Invalid menu options

The program displays an error message and asks the user to try again instead of terminating.

---

Files

grade_calculator.sh

The main Bash shell script.

grades.txt

Stores the currently entered student information and assessment grades.

test_data.txt

Contains sample test scenarios for testing the program.

README.txt

Contains project information and instructions for using the application.

---

How to Run the Program

Open a Linux/UNIX terminal and navigate to the project directory.

Make the script executable:

chmod +x grade_calculator.sh

Run the program:
bash grade_calculator.sh

---

Example Session

==============================================
          STUDENT GRADE CALCULATOR
==============================================

1. Enter Student Grade
2. Calculate Final Grade
3. Target Grade Calculator
4. View Letter Grade
5. Reset Data
6. Help
7. Exit

Choose one of the above options to continue: 1

ENTER STUDENT INFORMATION
==========================

Student Name: Peter Parker

ENTER ASSESSMENT MARKS
You can enter numerical grades or letter grades.

Assignment Mark: 85
Quiz Mark: A-
Test Mark: 80
Mid-term Mark: 75
Final Exam Mark: 88

ENTER ASSESSMENT WEIGHTS
The total weight must equal 100%.

Assignment Weight (%): 20
Quiz Weight (%): 10
Test Weight (%): 20
Mid-term Weight (%): 20
Final Exam Weight (%): 30

All information has been entered successfully.

Student information has been saved.

---

Team Responsibilities

Danylo - Team Lead

Responsibilities:

* Design the user interface.
* Design the user interaction flow.
* Create input forms.
* Create output displays.
* Write project description and documentation.
* Manage the GitHub repository.
* Integrate team members' code.
* Merge project components.
* Coordinate the project.
* Find and fix bugs.

Essa

Responsibilities:

* Develop grade calculation logic.
* Implement input validation.
* Implement error handling.
* Test the application.
* Assist with integration.

---

The project uses:

* Bash
* UNIX/Linux terminal
* `awk`
* `echo`
* `read`
* `printf`
* `case`
* `if`
* `while`
* Functions
* Text files
* Git
* GitHub

---


This project demonstrates practical knowledge of:

* Bash variables
* User input
* Conditional statements
* Loops
* Functions
* Arithmetic calculations
* Pattern matching
* File handling
* Input validation
* UNIX commands
* Git/GitHub collaboration
* Shell-script testing

---

The Student Grade Calculator provides students with a simple command-line tool for calculating their academic 
performance. It combines a user-friendly Bash interface with grade validation, weighted calculations, 
letter-grade conversion, target-grade calculations, and file storage.