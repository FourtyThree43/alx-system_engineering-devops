package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

func numberOfSubscribers(subreddit string) int {
	client := &http.Client{}

	url := fmt.Sprintf("https://www.reddit.com/r/%s/about.json", subreddit)
	req, err := http.NewRequest("GET", url, nil)

	if err != nil {
		return 0
	}

	req.Header.Set("User-Agent", "Go program")
	resp, err := client.Do(req)

	if err != nil {
		return 0
	}

	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		var data map[string]interface{}

		if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
			return 0
		}

		if result, ok := data["data"].(map[string]interface{}); ok {
			if subscribers, ok := result["subscribers"].(float64); ok {
				return int(subscribers)
			}
		}
	}

	return 0
}

func main() {
	if len(os.Args) != 2 {
		log.Fatal("Please pass an argument for the subreddit to search.")
	}
	subredditName := os.Args[1]
	subscribersCount := numberOfSubscribers(subredditName)
	fmt.Printf("%d\n", subscribersCount)
}
