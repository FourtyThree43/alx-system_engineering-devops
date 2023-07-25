#!/usr/bin/python3
"""
Script to fetch and display the progress of a specific employee's tasks
from a JSONPlaceholder API.
"""
import json
import requests

base_url = 'https://jsonplaceholder.typicode.com'


def export_all_tasks_to_JSON():
    """
    Fetches all tasks from all employees and exports them to a JSON file.
    """
    users_response = requests.get(f"{base_url}/users")
    if users_response.status_code != 200:
        print("Failed to fetch user information.")
        return

    users_list = {}
    for user in users_response.json():
        user_id = user.get('id')
        employee_name = user.get('name')

        todos_response = requests.get(f"{base_url}/todos",
                                      params={'userId': user_id})
        if todos_response.status_code != 200:
            print(f"Failed to fetch todos for employee ID {user_id}")
            return

        task_data_list = []
        for task in todos_response.json():
            task_data_list.append({
                "username": employee_name,
                "task": task.get("title"),
                "completed": task.get("completed")
            })

        users_list[user_id] = task_data_list

    # Export data to JSON file
    output_file = "todo_all_employees.json"
    with open(output_file, 'w') as json_file:
        json.dump(users_list, json_file)


if __name__ == "__main__":
    export_all_tasks_to_JSON()
