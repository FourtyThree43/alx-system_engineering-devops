#!/usr/bin/python3
"""
Script to fetch and display the progress of a specific employee's tasks
from a JSONPlaceholder API.
"""
import json
import requests
import sys

base_url = "https://jsonplaceholder.typicode.com"


def export_to_json(employee_id):
    """
    Fetches the progress of a specific employee's tasks
    and exports it to a Json file.
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
        task_data_list.append(
            {
                "task": task.get("title"),
                "completed": task.get("completed"),
                "username": employee_name
            }
        )

    # Export data to JSON file
    output_file = f"{employee_id}.json"
    with open(output_file, "w") as json_file:
        json.dump({f"{employee_id}": task_data_list}, json_file)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 2-export_to_json.py <EMPLOYEE_ID>")
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("<EMPLOYEE_ID> must be an integer.")
        sys.exit(1)

    export_to_json(employee_id)
