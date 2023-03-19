package main

import (
	"fmt"
	"regexp"
)

func main() {
	match, _ := regexp.MatchString("Mihalis", "Mihalis Tsoukalos")
	fmt.Println(match)
	match, _ = regexp.MatchString("Tsoukalos", "Mihalis tsoukalos")
	fmt.Println(match)
}
