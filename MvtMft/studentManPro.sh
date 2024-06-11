validate_login() {
    echo "Enter Username:"
    read username

    echo "Enter Password:"
    read -s password  

    if [ "$username" == "green.90" ] && [ "$password" == "green.99" ]; then
        echo "Login successful!"
        main_menu  
    else
        echo "Invalid credentials. Please try again."
        exit 1  
    fi
}

add_student() {
    echo "Enter ID Number:"
    read id
    [ -z "$id" ] && { echo "ID cannot be empty"; return; }

    echo "Enter Name:"
    read name
    [ -z "$name" ] && { echo "Name cannot be empty"; return; }

    echo "Enter Age:"
    read age
    [ -z "$age" ] && { echo "Age cannot be empty"; return; }

    echo "Enter CGPA:"
    read cgpa
    [ -z "$cgpa" ] && { echo "CGPA cannot be empty"; return; }

    echo "$id,$name,$age,$cgpa" >> students.csv
    echo "Student added successfully!"
}

view_all_students() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "All Students:"
    cat students.csv
}

search_by_id() {
    echo "Enter ID Number to search:"
    read id
    [ -z "$id" ] && { echo "ID cannot be empty"; return; }

    grep "^$id," students.csv || echo "Student not found."
}

search_by_name() {
    echo "Enter Name to search:"
    read name
    [ -z "$name" ] && { echo "Name cannot be empty"; return; }

    grep ",$name," students.csv || echo "Student not found."
}

update_student_info() {
    echo "Enter ID Number to update:"
    read id
    [ -z "$id" ] && { echo "ID cannot be empty"; return; }

    echo "Enter New Name:"
    read new_name
    [ -z "$new_name" ] && { echo "Name cannot be empty"; return; }

    if grep -q "^$id," students.csv; then
        sed -i "s/^$id,[^,]*/$id,$new_name/" students.csv
        echo "Student information updated successfully!"
    else
        echo "Student ID not found."
    fi
}

delete_student() {
    echo "Enter ID Number to delete:"
    read id
    [ -z "$id" ] && { echo "ID cannot be empty"; return; }

    if grep -q "^$id," students.csv; then
        sed -i "/^$id,/d" students.csv
        echo "Student deleted successfully!"
    else
        echo "Student ID not found."
    fi
}

view_student_count() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "Total Number of Students: $(wc -l < students.csv)"
}

view_student_names() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "Student Names:"
    cut -d ',' -f 2 students.csv
}

view_sorted_by_name() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "Student Details Sorted by Name:"
    sort -t ',' -k 2 students.csv
}

generate_cgpa_report() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "CGPA Report:"
    awk -F ',' '{print $4}' students.csv | sort | uniq -c
}

find_oldest_student() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "Oldest Student:"
    sort -t ',' -k 3 -nr students.csv | head -n 1
}

find_youngest_student() {
    if [ ! -f students.csv ]; then
        echo "No student data found."
        return
    fi
    echo "Youngest Student:"
    sort -t ',' -k 3 -n students.csv | head -n 1
}

export_to_file() {
    echo "Enter the file name to export data to:"
    read filename
    [ -z "$filename" ] && { echo "Filename cannot be empty"; return; }

    if [ -e students.csv ]; then
        cp students.csv "$filename"
        echo "Data exported to $filename successfully!"
    else
        echo "No student data to export. Add students first."
    fi
}

import_from_file() {
    echo "Enter the file name to import data from:"
    read filename
    [ -z "$filename" ] && { echo "Filename cannot be empty"; return; }

    if [ -e "$filename" ]; then
        cp "$filename" students.csv
        echo "Data imported from $filename successfully!"
    else
        echo "File not found. Make sure the file exists and try again."
    fi
}

main_menu() {
    while true; do
        echo "Student Management System"
        echo "1. Add Student"
        echo "2. View All Students"
        echo "3. Search Student by ID"
        echo "4. Search Student by Name"
        echo "5. Update Student Information"
        echo "6. Delete Student"
        echo "7. View Student Count"
        echo "8. View Student Names"
        echo "9. View Student Details Sorted by Name"
        echo "10. Generate CGPA Report"
        echo "11. Find Oldest Student"
        echo "12. Find Youngest Student"
        echo "13. Export Student Information to File"
        echo "14. Import Student Information from File"
        echo "15. Exit"

        read choice

        case $choice in
            1) add_student ;;
            2) view_all_students ;;
            3) search_by_id ;;
            4) search_by_name ;;
            5) update_student_info ;;
            6) delete_student ;;
            7) view_student_count ;;
            8) view_student_names ;;
            9) view_sorted_by_name ;;
            10) generate_cgpa_report ;;
            11) find_oldest_student ;;
            12) find_youngest_student ;;
            13) export_to_file ;;
            14) import_from_file ;;
            15) exit 0 ;;
            *) echo "Invalid choice, please try again." ;;
        esac
    done
}

validate_login
