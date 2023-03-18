package main

import (
	"fmt"
	"os"
)

func main() {
	arguments := os.Args
	for _, arg := range arguments {
		fmt.Println(arg)
	}
}
