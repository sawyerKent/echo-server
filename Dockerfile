# Use an official Golang Alpine runtime as a parent image
FROM golang:1.16-alpine as builder

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the Go app
RUN apk add --no-cache git && \
    go build -o main .

# Use scratch runtime as a base image
FROM scratch

# Copy the binary from the previous stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]


# # Use an official Golang runtime as a parent image
# FROM golang:1.20

# # Set the working directory to /app
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Build the Go app
# RUN go build -o main .

# # Expose port 8080 to the outside world
# EXPOSE 8080

# # Command to run the executable
# CMD ["./main"]
