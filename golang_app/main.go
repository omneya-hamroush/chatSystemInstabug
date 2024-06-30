package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"log"
	"time"

	"github.com/go-redis/redis/v8"
	_ "github.com/go-sql-driver/mysql"
)

var ctx = context.Background()
var db *sql.DB

type Chat struct {
	ApplicationID int `json:"application_id"`
	Number        int `json:"number"`
}

func main() {
	// Initialize Redis client
	rdb := redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})
	log.Println("ON GOOOOOOOOOOOOOOOOOOOOOOOO")
	// Initialize MySQL client
	// dsn := "root:root@tcp(mysql:3306)/dev?charset=utf8mb4&parseTime=True&loc=Local"
	// db, err := sql.Open("mysql", "user:root@tcp(mysql:3306)/dev")
	// // db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	// if err != nil {
	// 	log.Fatalf("failed to connect to MySQL: %v", err)
	// }

	var err error
	db, err = sql.Open("mysql", "root:root@tcp(mysql:3306)/dev")
	log.Println("DBDD BRFOREEEEEE", err)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	for {
		result, err := rdb.BRPop(ctx, time.Second*120, "golang_chats").Result()
		log.Println("TRSSSSSSSSSSSSSSSSSSSSs", result)
		if err != nil {
			if err != redis.Nil {
				log.Println("Error popping message from Redis:", err)
			}
			continue
		}

		var chat Chat
		err = json.Unmarshal([]byte(result[1]), &chat)
		if err != nil {
			log.Println("Error decoding JSON:", err)
			continue
		}

		// Process the chat (insert into MySQL)
		log.Println("BEFOREEE INSERTTTTTTTT", chat)
		go insertChat(chat)
		// go processChat(db, chat)
	}
}

func insertChat(chat Chat) {
	// Prepare the insert statement
	insertStmt, err := db.Prepare("INSERT INTO chats (application_id) VALUES (?)")
	log.Println("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", insertStmt, "ERROFFFFF:", err, "CHAYYYYYYY:", chat.ApplicationID)
	if err != nil {
		log.Println("Error preparing insert statement:", err)
		return
	}
	defer insertStmt.Close()

	// Execute the insert statement with values from the chat
	log.Println("LOGGGGGGGGGGGG")
	_, err = insertStmt.Exec(chat.ApplicationID)
	if err != nil {
		log.Println("Error inserting chat:", err)
		return
	}

	log.Println("Inserted chat: %+v\n", chat)
}

// func processChat(db *gorm.DB, chat Chat) {
// 	// Simulate database insertion or any processing
// 	log.Printf("Processing chat: %+v\n", chat)
// 	// Replace with actual database logic to create chats in your database
// 	err := db.Create(&chat).Error
// 	if err != nil {
// 		log.Printf("Error creating chat in database: %v", err)
// 	}
// }

// package main

// import (
// 	"context"
// 	"encoding/json"
// 	"log"

// 	"github.com/go-redis/redis"
// )

// var ctx = context.Background()

// type Chat struct {
// 	ApplicationID int `json:"application_id"`
// 	Number        int `json:"number"`
// }

// func main() {
// 	rdb := redis.NewClient(&redis.Options{
// 		Addr:     "redis:6379", // Adjust address based on Docker Compose setup
// 		Password: "",           // No password set
// 		DB:       0,            // Use default DB
// 	})
// 	// dsn := "user:root@tcp(mysql:3306)/dev" // Adjust as needed
// 	// db, err := sql.Open("mysql", dsn)
// 	// if err != nil {
// 	// 	log.Fatal(err)
// 	// }
// 	// defer db.Close()

// 	// if err := db.Ping(); err != nil {
// 	// 	log.Fatal(err)
// 	// }

// 	// log.Println("Successfully connected to the database")

// 	for {
// 		result, err := rdb.BRPop(6000000000, "golang_chats").Result()
// 		log.Println("RESULTTT POPPINGGG", result)
// 		if err != nil {
// 			log.Println("Error popping message from Redis:", err)
// 			continue
// 		}

// 		var chat Chat
// 		log.Println("RESULTTT POPPINGGG22222222222222222222222", result)
// 		err = json.Unmarshal([]byte(result[1]), &chat)
// 		if err != nil {
// 			log.Println("Error decoding JSON:", err)
// 			continue
// 		}

// 		// Simulate database insertion or any processing
// 		log.Printf("Processing chat: %+v\n", chat)
// 		// Replace with actual database logic to create chats in your database
// 	}
// }
