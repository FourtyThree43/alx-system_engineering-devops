#!/usr/bin/python3
"""
0-top_ten
"""
import requests


def top_ten(subreddit):
    """
    Prints the titles of the first 10 hot posts listed for a given subreddit.
    """
    url = f'https://www.reddit.com/r/{subreddit}/hot.json?limit=10'
    headers = {"User-Agent": "Python/requests"}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        try:
            results = response.json().get("data")
            [
                print(c.get("data").get("title"))
                for c in results.get("children")
            ]

        except KeyError:
            return 0
    else:
        return 0
