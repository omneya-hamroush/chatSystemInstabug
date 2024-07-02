# README

# Restful chat system application
This application is dockerized to simplify setup and deployment. Follow these steps to run the application using Docker:

1- Ensure Docker is installed on your system.

2- Clone the repository to your local machine.

3- Navigate to the project directory.

4- Start the Docker containers:

docker-compose up

# Technical Details Covered:

1- Mysql used as the main database adapter.
2- Restful CRUD APIs implemented for application, chat, and messaging models.
3- Elasticsearch integrated for message search within chats based on message content and chat_id using N-gram tokenizer.
4- Redis used to enqueue new chats and messages and run their creation in a Golang app using go routines
5- Implemented a cron job that runs every 30 minutes to update the chats_count in applications table and messages_count in chats table
