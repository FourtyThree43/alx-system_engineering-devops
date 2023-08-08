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
	req, err:= http.NewRequest("Get", url, nil)

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
		//
		return int(subscribers)
	}

	return 0
}

func main() {
	if len(os.Args) != 2 {
		log.Fatal("Please pass an argument for the subreddit to search.")
	}
	subredditName := os.Args[1]
	subscribersCount := numberOfSubscribers(subredditName)
	fmt.Println("%d", subscribersCount)

}