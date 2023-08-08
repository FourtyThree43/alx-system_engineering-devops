#!/usr/bin/python3
"""
0-sub.py
"""
import requests


def number_of_subscribers(subreddit):
    """
    Returns the number of subscribers (not active users, total subscribers)
    for a given subreddit
    """
    url = f'https://www.reddit.com/r/{subreddit}/about.json'
    headers = {"User-Agent": "Python/requests"}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        try:
            data = response.json()
            result = data.get('data')
            subscribers = result.get('subscribers')
            return subscribers

        except KeyError:
            return 0
    else:
        return 0
