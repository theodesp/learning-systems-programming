package main

import (
	"fmt"
	"os"
)

func main2() {
	arguments := os.Args
	for _, arg := range arguments {
		fmt.Println(arg)
	}
}
