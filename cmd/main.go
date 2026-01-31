package main

import (
	"fmt"
	"log"
	"rpc/internal/handler"

	"github.com/gin-gonic/gin"
)

func main() {
	fmt.Println("hello world")

	r := gin.Default()

	r.GET("/ping", handler.Ping)

	if err := r.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}
