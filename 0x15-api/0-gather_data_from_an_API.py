#!/usr/bin/python3
"""
Script to fetch and display the progress of a specific employee's tasks
from a JSONPlaceholder API.
"""
import requests
import sys

base_url = "https://jsonplaceholder.typicode.com"


def gather_data_from_an_API(employee_id):
    """Gather data from an API"""
    user_url = f"{base_url}/users/{employee_id}"
    todos_url = f"{base_url}/todos?userId={employee_id}"

    user_response = requests.get(user_url)
    if user_response.status_code != 200:
        print(f"Failed to fetch user info for EMPLOYEE_ID:{employee_id}")
        return

    EMPLOYEE_NAME = user_response.json().get("name")

    TOTAL_NUMBER_OF_TASKS = 0
    NUMBER_OF_DONE_TASKS = 0
    TASK_TITLE = []

    todos_response = requests.get(todos_url)
    if todos_response.status_code != 200:
        print(f"Failed to fetch todos for <EMPLOYEE_ID>: {employee_id}")
        return

    for task in todos_response.json():
        TOTAL_NUMBER_OF_TASKS += 1
        if task.get("completed"):
            NUMBER_OF_DONE_TASKS += 1
            TASK_TITLE.append(task.get("title"))

    print(
        "Employee {} is done with tasks({}/{}):".format(
            EMPLOYEE_NAME, NUMBER_OF_DONE_TASKS, TOTAL_NUMBER_OF_TASKS
        )
    )
    for task in TASK_TITLE:
        print(f"\t {task}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 0-gather_data_from_an_API.py <EMPLOYEE_ID>")
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("<EMPLOYEE_ID> must be an integer.")
        sys.exit(1)

    gather_data_from_an_API(employee_id)
