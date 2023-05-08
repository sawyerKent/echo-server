# Build the Go app
FROM golang:alpine as builder
WORKDIR /app
COPY . /app
RUN apk add --no-cache git && \
    go build -o main .

# Create a scratch container
FROM scratch
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]
