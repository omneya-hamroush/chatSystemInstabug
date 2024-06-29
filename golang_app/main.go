package main

// import (
// 	"fmt"
// 	"net/http"
// )

// func main() {
// 	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
// 		fmt.Fprintf(w, "Hello from Golang!")
// 	})

// 	fmt.Println("Golang server listening on :8080...")
// 	http.ListenAndServe(":8080", nil)
// }

import (
	"encoding/json"
	"log"

	"github.com/streadway/amqp"
)

type Chat struct {
	UserID  int    `json:"user_id"`
	Message string `json:"message"`
}

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
	}
}

func main() {
	conn, err := amqp.Dial("amqp://guest:guest@rabbitmq:5672/")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	ch, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch.Close()

	q, err := ch.QueueDeclare(
		"chats",
		true,
		false,
		false,
		false,
		nil,
	)
	failOnError(err, "Failed to declare a queue")

	msgs, err := ch.Consume(
		q.Name,
		"",
		true,
		false,
		false,
		false,
		nil,
	)
	failOnError(err, "Failed to register a consumer")

	forever := make(chan bool)

	go func() {
		for d := range msgs {
			var chat Chat
			err := json.Unmarshal(d.Body, &chat)
			if err != nil {
				log.Printf("Error decoding JSON: %s", err)
			} else {
				log.Printf("Received a chat: %+v", chat)
				// Process chat and store in MySQL
				saveChat(chat)
			}
		}
	}()

	log.Printf("Waiting for messages. To exit press CTRL+C")
	<-forever
}

func saveChat(chat Chat) {
	// Implement the function to save chat to MySQL using database/sql or gorm
}
