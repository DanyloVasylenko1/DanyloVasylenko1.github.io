#!/bin/bash


DATA_FILE="grades.txt"

student_name=""
assignment_mark=""
quiz_mark=""
test_mark=""
midterm_mark=""
final_exam_mark=""

assignment_weight=""
quiz_weight=""
test_weight=""
midterm_weight=""
final_exam_weight=""

total_weight=""
final_grade=""
letter_grade=""



display_header() {
    clear

    echo "=============================================="
    echo "          STUDENT GRADE CALCULATOR"
    echo "=============================================="
    echo
}



pause_screen() {
    echo
    read -r -p "Press Enter to continue..." _
}



convert_letter_grade() {

    case "$1" in
        A|a)
            echo "95"
            ;;
        A-|a-)
            echo "90"
            ;;
        B+|b+)
            echo "88"
            ;;
        B|b)
            echo "85"
            ;;
        B-|b-)
            echo "80"
            ;;
        C+|c+)
            echo "78"
            ;;
        C|c)
            echo "75"
            ;;
        C-|c-)
            echo "70"
            ;;
        D+|d+)
            echo "68"
            ;;
        D|d)
            echo "65"
            ;;
        D-|d-)
            echo "60"
            ;;
        F|f)
            echo "50"
            ;;
        *)
            return 1
            ;;
    esac
}



get_mark() {

    local prompt="$1"
    local input=""
    local numeric_value=""

    while true
    do
        printf "%s" "$prompt" >&2
        read -r input

        if [ -z "$input" ]
        then
            echo "Error: A mark is required." >&2
            continue
        fi

        if [[ "$input" =~ ^[AaBbCcDdFf][+-]?$ ]]
        then
            if numeric_value=$(convert_letter_grade "$input")
            then
                echo "$numeric_value"
                return
            fi
        fi

        if [[ "$input" =~ ^[0-9]+([.][0-9]+)?$ ]]
        then
            if awk -v value="$input" 'BEGIN { exit !(value >= 0 && value <= 100) }'
            then
                echo "$input"
                return
            else
                echo "Error: Mark must be between 0 and 100." >&2
                continue
            fi
        fi

        echo "Error: Enter a number from 0-100 or a valid letter grade." >&2
        echo "Examples: 85, 92.5, A, B+, C, F" >&2
    done
}



get_weight() {

    local prompt="$1"
    local input=""

    while true
    do
        printf "%s" "$prompt" >&2
        read -r input

        if [ -z "$input" ]
        then
            echo "Error: A weight is required." >&2
            continue
        fi

        if [[ "$input" =~ ^[0-9]+([.][0-9]+)?$ ]]
        then
            if awk -v value="$input" 'BEGIN { exit !(value >= 0 && value <= 100) }'
            then
                echo "$input"
                return
            else
                echo "Error: Weight must be between 0 and 100." >&2
            fi
        else
            echo "Error: Please enter a numerical weight from 0 to 100." >&2
        fi
    done
}



calculate_total_weight() {

    total_weight=$(awk "BEGIN {
        print $assignment_weight + $quiz_weight + $test_weight + $midterm_weight + $final_exam_weight
    }")

    total_weight=$(printf "%.2f" "$total_weight")
}



calculate_final_grade() {

    calculate_total_weight

    if ! awk -v total="$total_weight" 'BEGIN { exit !(total == 100) }'
    then
        echo
        echo "Error: Assessment weights must total exactly 100%."
        echo "Current total: $total_weight%"
        return 1
    fi

    final_grade=$(awk "BEGIN {
        result = \
        ($assignment_mark * $assignment_weight / 100) + \
        ($quiz_mark * $quiz_weight / 100) + \
        ($test_mark * $test_weight / 100) + \
        ($midterm_mark * $midterm_weight / 100) + \
        ($final_exam_mark * $final_exam_weight / 100)

        printf \"%.2f\", result
    }")

    determine_letter_grade
}



determine_letter_grade() {

    if [ -z "$final_grade" ]
    then
        letter_grade=""
        return
    fi

    letter_grade=$(awk -v grade="$final_grade" 'BEGIN {
        if (grade >= 80)
            print "A"
        else if (grade >= 70)
            print "B"
        else if (grade >= 60)
            print "C"
        else if (grade >= 50)
            print "D"
        else
            print "F"
    }')
}



enter_grades() {

    display_header

    echo "ENTER STUDENT INFORMATION"
    echo "========================="
    echo

    read -r -p "Student Name: " student_name

    while [ -z "$student_name" ]
    do
        echo "Error: Student name cannot be empty."
        read -r -p "Student Name: " student_name
    done

    echo
    echo "ENTER ASSESSMENT MARKS"
    echo "-----------------------"
    echo "You may enter a numerical mark or letter grade."
    echo "Examples: 85, 92.5, A, B+, C, F"
    echo

    assignment_mark=$(get_mark "Assignment Mark: ")
    quiz_mark=$(get_mark "Quiz Mark: ")
    test_mark=$(get_mark "Test Mark: ")
    midterm_mark=$(get_mark "Mid-term Mark: ")
    final_exam_mark=$(get_mark "Final Exam Mark: ")

    echo
    echo "ENTER ASSESSMENT WEIGHTS"
    echo "------------------------"

    assignment_weight=$(get_weight "Assignment Weight (%): ")
    quiz_weight=$(get_weight "Quiz Weight (%): ")
    test_weight=$(get_weight "Test Weight (%): ")
    midterm_weight=$(get_weight "Mid-term Weight (%): ")
    final_exam_weight=$(get_weight "Final Exam Weight (%): ")

    calculate_total_weight

    while ! awk -v total="$total_weight" 'BEGIN { exit !(total == 100) }'
    do
        echo
        echo "=============================================="
        echo "ERROR: Assessment weights must total 100%."
        echo "Current total: $total_weight%"
        echo "=============================================="
        echo
        echo "Please enter the assessment weights again."
        echo

        assignment_weight=$(get_weight "Assignment Weight (%): ")
        quiz_weight=$(get_weight "Quiz Weight (%): ")
        test_weight=$(get_weight "Test Weight (%): ")
        midterm_weight=$(get_weight "Mid-term Weight (%): ")
        final_exam_weight=$(get_weight "Final Exam Weight (%): ")

        calculate_total_weight
    done

    final_grade=""
    letter_grade=""

    save_data

    echo
    echo "=============================================="
    echo "Student information has been saved successfully."
    echo "Total assessment weight: $total_weight%"
    echo "=============================================="

    pause_screen
}


save_data() {

    cat > "$DATA_FILE" << EOF
Student Name: $student_name

Assignment Mark: $assignment_mark
Assignment Weight: $assignment_weight%

Quiz Mark: $quiz_mark
Quiz Weight: $quiz_weight%

Test Mark: $test_mark
Test Weight: $test_weight%

Mid-term Mark: $midterm_mark
Mid-term Weight: $midterm_weight%

Final Exam Mark: $final_exam_mark
Final Exam Weight: $final_exam_weight%

Total Weight: $total_weight%
Final Grade: ${final_grade:-Not calculated}
Letter Grade: ${letter_grade:-Not calculated}
EOF
}



display_results() {

    echo
    echo "=============================================="
    echo "          STUDENT GRADE RESULTS"
    echo "=============================================="
    echo
    echo "Student Name: $student_name"
    echo
    printf "%-20s %-10s %-10s\n" "Assessment" "Mark" "Weight"
    echo "----------------------------------------------"
    printf "%-20s %-10s %-10s\n" "Assignment" "$assignment_mark%" "$assignment_weight%"
    printf "%-20s %-10s %-10s\n" "Quiz" "$quiz_mark%" "$quiz_weight%"
    printf "%-20s %-10s %-10s\n" "Test" "$test_mark%" "$test_weight%"
    printf "%-20s %-10s %-10s\n" "Mid-term" "$midterm_mark%" "$midterm_weight%"
    printf "%-20s %-10s %-10s\n" "Final Exam" "$final_exam_mark%" "$final_exam_weight%"
    echo
    echo "----------------------------------------------"
    printf "Weighted Final Grade: %s%%\n" "$final_grade"
    printf "Letter Grade:         %s\n" "$letter_grade"
    echo "=============================================="
}



calculate_grade_menu() {

    display_header

    if [ -z "$student_name" ]
    then
        echo "No student data has been entered."
        echo "Please select Option 1 first."
        pause_screen
        return
    fi

    if calculate_final_grade
    then
        save_data
        display_results
    fi

    pause_screen
}



view_letter_grade() {

    display_header

    if [ -z "$student_name" ]
    then
        echo "No student data has been entered."
        echo "Please select Option 1 first."
        pause_screen
        return
    fi

    if [ -z "$final_grade" ]
    then
        if ! calculate_final_grade
        then
            pause_screen
            return
        fi
    fi

    echo "STUDENT GRADE"
    echo "-------------"
    echo
    echo "Student Name: $student_name"
    echo
    echo "Numerical Grade: $final_grade%"
    echo "Letter Grade:    $letter_grade"

    pause_screen
}



target_grade_calculator() {

    display_header

    if [ -z "$student_name" ]
    then
        echo "No student data has been entered."
        echo "Please select Option 1 first."
        pause_screen
        return
    fi

    calculate_total_weight

    if ! awk -v total="$total_weight" 'BEGIN { exit !(total == 100) }'
    then
        echo "Error: Assessment weights must total 100%."
        echo "Current total: $total_weight%"
        pause_screen
        return
    fi

    echo "TARGET GRADE CALCULATOR"
    echo "======================="
    echo
    echo "Enter the desired final course grade."
    echo "Examples: 80, 85, 90, A, B+, B"
    echo

    target_grade=$(get_mark "Target Grade: ")

    if awk -v target="$target_grade" 'BEGIN { exit !(target >= 100) }'
    then
        echo
        echo "Error: Target grade cannot be greater than 100%."
        pause_screen
        return
    fi

    if awk -v weight="$final_exam_weight" 'BEGIN { exit !(weight == 0) }'
    then
        echo
        echo "Error: Final exam weight is 0%."
        echo "A target grade cannot be calculated from the final exam."
        pause_screen
        return
    fi

    current_grade=$(awk "BEGIN {
        result = \
        ($assignment_mark * $assignment_weight / 100) + \
        ($quiz_mark * $quiz_weight / 100) + \
        ($test_mark * $test_weight / 100) + \
        ($midterm_mark * $midterm_weight / 100)

        printf \"%.2f\", result
    }")

    required_exam=$(awk "BEGIN {
        result = (($target_grade - $current_grade) / $final_exam_weight) * 100
        printf \"%.2f\", result
    }")

    echo
    echo "=============================================="
    echo "TARGET GRADE RESULTS"
    echo "=============================================="
    echo
    echo "Current contribution: $current_grade%"
    echo "Target final grade:   $target_grade%"
    echo
    echo "Required final exam mark: $required_exam%"
    echo

    if awk -v required="$required_exam" 'BEGIN { exit !(required > 100) }'
    then
        echo "The required final exam mark is above 100%."
        echo "The target grade is not mathematically achievable."
    elif awk -v required="$required_exam" 'BEGIN { exit !(required <= 0) }'
    then
        echo "You have already achieved the target grade."
        echo "A 0% on the final exam would still meet the target."
    else
        echo "You need approximately $required_exam% on the final exam."
    fi

    echo "=============================================="

    pause_screen
}



reset_data() {

    display_header

    if [ -z "$student_name" ]
    then
        echo "There is currently no student data to reset."
        pause_screen
        return
    fi

    echo "Current student: $student_name"
    echo
    read -r -p "Are you sure you want to reset all data? (y/n): " response

    case "$response" in

        y|Y)
            student_name=""

            assignment_mark=""
            quiz_mark=""
            test_mark=""
            midterm_mark=""
            final_exam_mark=""

            assignment_weight=""
            quiz_weight=""
            test_weight=""
            midterm_weight=""
            final_exam_weight=""

            total_weight=""
            final_grade=""
            letter_grade=""

            > "$DATA_FILE"

            echo
            echo "All student grade data has been successfully reset."
            ;;

        n|N)
            echo
            echo "Reset cancelled."
            ;;

        *)
            echo
            echo "Invalid response. No data was changed."
            ;;

    esac

    pause_screen
}



help_menu() {

    display_header

    echo "HELP - STUDENT GRADE CALCULATOR"
    echo "==============================="
    echo

    echo "Option 1 - Enter Student Grade"
    echo "Enter the student's name, assessment marks,"
    echo "and assessment weights."
    echo

    echo "Option 2 - Calculate Final Grade"
    echo "Calculates the weighted final course grade."
    echo

    echo "Option 3 - Target Grade Calculator"
    echo "Calculates the score needed on the final exam"
    echo "to achieve a desired final course grade."
    echo

    echo "Option 4 - View Letter Grade"
    echo "Displays the numerical and corresponding"
    echo "letter grade."
    echo

    echo "Option 5 - Reset Data"
    echo "Deletes the currently entered student data."
    echo

    echo "Option 6 - Help"
    echo "Displays these instructions."
    echo

    echo "Option 7 - Exit"
    echo "Closes the application."
    echo

    echo "INPUT RULES"
    echo "-----------"
    echo "- Numerical marks must be between 0 and 100."
    echo "- Letter grades such as A, B+, B, C, and F are accepted."
    echo "- Assessment weights must be between 0 and 100."
    echo "- All assessment weights must total exactly 100%."
    echo

    echo "LETTER GRADE SCALE"
    echo "------------------"
    echo "A = 80-100"
    echo "B = 70-79"
    echo "C = 60-69"
    echo "D = 50-59"
    echo "F = 0-49"

    pause_screen
}



exit_program() {

    display_header

    echo "Thank you for using the Student Grade Calculator."
    echo
    echo "Goodbye!"

    exit 0
}



if [ ! -f "$DATA_FILE" ]
then
    touch "$DATA_FILE"
fi



main_menu() {

    while true
    do
        display_header

        echo "1. Enter Student Grade"
        echo "2. Calculate Final Grade"
        echo "3. Target Grade Calculator"
        echo "4. View Letter Grade"
        echo "5. Reset Data"
        echo "6. Help"
        echo "7. Exit"
        echo
        echo "Choose one of the above options to continue:"
        read -r choice

        case "$choice" in

            1)
                enter_grades
                ;;

            2)
                calculate_grade_menu
                ;;

            3)
                target_grade_calculator
                ;;

            4)
                view_letter_grade
                ;;

            5)
                reset_data
                ;;

            6)
                help_menu
                ;;

            7)
                exit_program
                ;;

            *)
                echo
                echo "Error: Invalid menu option."
                echo "Please choose an option from 1 to 7."
                sleep 2
                ;;

        esac
    done
}



main_menu
