package main

import(
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func topTen(subreddit string){
	url := fmt.Sprintf("https://www.reddit.com/r/%s/about.json", subreddit)
	req, err := http.NewRequest("GET", url, nil)

	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	client := &http.Client{}
	req.Header.Set("User-Agent", "Go program")
	resp, err := client.Do(req)

	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		var data map[string]interface{}

		if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}

		posts := data["data"].(map[string]interface{})["children"].([]interface{})

		for _, post := range posts {
			postData := post.(map[string]interface{})["data"].(map[string]interface{})
			title := postData["title"].(string)
			fmt.Println(title)
		}
	} else {
		fmt.Println("Invalid subreddit")
	}
}


func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "Please pass an argument for the subreddit to search")
		os.Exit(1)
	}

	subredditName := os.Args[1]
	topTen(subredditName)
}
