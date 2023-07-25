#!/usr/bin/python3
"""
Script to fetch and display the progress of a specific employee's tasks
from a JSONPlaceholder API.
"""
import csv
import requests
import sys

base_url = "https://jsonplaceholder.typicode.com"


def export_to_CSV(employee_id):
    """
    Fetches the progress of a specific employee's tasks
    and exports it to a CSV file.
    """
    user_url = f"{base_url}/users/{employee_id}"
    todos_url = f"{base_url}/todos?userId={employee_id}"

    user_response = requests.get(user_url)
    if user_response.status_code != 200:
        print(f"Failed to fetch user info for EMPLOYEE_ID:{employee_id}")
        return

    employee_name = user_response.json().get("name")

    todos_response = requests.get(todos_url)
    if todos_response.status_code != 200:
        print(f"Failed to fetch todos for <EMPLOYEE_ID>: {employee_id}")
        return

    task_data_list = []
    for task in todos_response.json():
        task_data_list.append((task.get("completed"), task.get("title")))

    # export to csv
    output_csv_file = f"{employee_id}.csv"
    with open(output_csv_file, "w", newline="") as csv_file:
        fieldnames = ["USER_ID", "USERNAME", "TASK_COMPLETED_STATUS",
                      "TASK_TITLE"]
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames,
                                quoting=csv.QUOTE_ALL)
        for task in task_data_list:
            writer.writerow(
                {
                    "USER_ID": employee_id,
                    "USERNAME": employee_name,
                    "TASK_COMPLETED_STATUS": task[0],
                    "TASK_TITLE": task[1],
                }
            )


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 1-export_to_CSV.py <EMPLOYEE_ID>")
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("<EMPLOYEE_ID> must be an integer.")
        sys.exit(1)

    export_to_CSV(employee_id)
