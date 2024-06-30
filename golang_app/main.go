package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
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

type Message struct {
	ChatID  int    `json:"chat_id"`
	Content string `json:"content"`
	Number  int    `json:"number"`
}

func initDB() (*sql.DB, error) {
	db, err := sql.Open("mysql", "root:root@tcp(mysql:3306)/dev")
	if err != nil {
		return nil, err
	}
	return db, nil
}

func getNextChatNumber(tx *sql.Tx, applicationID int) (int, error) {
	var maxNumber int
	query := "SELECT COALESCE(MAX(number), 0) FROM chats WHERE application_id = ? FOR UPDATE"
	err := tx.QueryRow(query, applicationID).Scan(&maxNumber)
	if err != nil {
		return 0, err
	}
	return maxNumber + 1, nil
}

func getNextMessageNumber(tx *sql.Tx, chatID int) (int, error) {
	var maxNumber int
	query := "SELECT COALESCE(MAX(number), 0) FROM messages WHERE chat_id = ? FOR UPDATE"
	err := tx.QueryRow(query, chatID).Scan(&maxNumber)
	if err != nil {
		return 0, err
	}
	return maxNumber + 1, nil
}

func main() {
	db, err := initDB()
	if err != nil {
		log.Fatalf("failed to connect to MySQL: %v", err)
	}
	defer db.Close()

	var wg sync.WaitGroup

	// Initialize Redis client
	rdb := redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})
	log.Println("ON GOOOOOOOOOOOOOOOOOOOOOOOO")

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		for {
			select {
			case <-quit:
				return
			default:
				result, err := rdb.BRPop(ctx, time.Second*120, "golang_chats").Result()
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

				wg.Add(1)
				go processChatCreation(db, &wg, chat)
			}
		}
	}()

	go func() {
		for {
			select {
			case <-quit:
				return
			default:
				result, err := rdb.BRPop(ctx, time.Second*120, "golang_messages").Result()
				if err != nil {
					if err != redis.Nil {
						log.Println("Error popping message from Redis:", err)
					}
					continue
				}

				var message Message
				err = json.Unmarshal([]byte(result[1]), &message)
				if err != nil {
					log.Println("Error decoding JSON:", err)
					continue
				}

				wg.Add(1)
				go processMessageCreation(db, &wg, message)
			}
		}
	}()

	<-quit
	log.Println("Received termination signal, waiting for all go routines to complete...")
	wg.Wait()
	log.Println("All chat and message creation requests processed.")
}

func processChatCreation(db *sql.DB, wg *sync.WaitGroup, chat Chat) {
	defer wg.Done()

	tx, err := db.Begin()
	if err != nil {
		log.Println("Error starting transaction:", err)
		return
	}
	defer tx.Rollback()

	number, err := getNextChatNumber(tx, chat.ApplicationID)
	if err != nil {
		log.Println("Error getting next chat number:", err)
		return
	}

	err = insertChat(tx, chat.ApplicationID, number)
	if err != nil {
		log.Println("Error inserting chat:", err)
		return
	}

	err = tx.Commit()
	if err != nil {
		log.Println("Error committing transaction:", err)
		return
	}

	log.Printf("Successfully inserted chat for application %d with number %d\n", chat.ApplicationID, number)
}

func processMessageCreation(db *sql.DB, wg *sync.WaitGroup, message Message) {
	defer wg.Done()

	tx, err := db.Begin()
	if err != nil {
		log.Println("Error starting transaction:", err)
		return
	}
	defer tx.Rollback()

	number, err := getNextMessageNumber(tx, message.ChatID)
	if err != nil {
		log.Println("Error getting next message number:", err)
		return
	}

	err = insertMessage(tx, message.ChatID, number, message.Content)
	if err != nil {
		log.Println("Error inserting message:", err)
		return
	}

	err = tx.Commit()
	if err != nil {
		log.Println("Error committing transaction:", err)
		return
	}

	log.Printf("Successfully inserted message for chat %d with number %d\n", message.ChatID, number)
}

func insertChat(tx *sql.Tx, applicationID int, number int) error {
	query := "INSERT INTO chats (application_id, number, created_at, updated_at) VALUES (?, ?, NOW(), NOW())"
	_, err := tx.Exec(query, applicationID, number)
	return err
}

func insertMessage(tx *sql.Tx, chatID int, number int, content string) error {
	query := "INSERT INTO messages (chat_id, number, content, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())"
	_, err := tx.Exec(query, chatID, number, content)
	return err
}
