# Use an official Golang runtime as a parent image
FROM golang:1.18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the local package files to the container's workspace
COPY . .

# Build the Go app
RUN go build -o golang_app

# Command to run the executable
CMD ["./golang_app"]
