package main

import (
    "net/http"

    "github.com/labstack/echo/v4"
)

func main() {
    // Create a new Echo instance
    e := echo.New()

    // Define a route handler for the root path
    e.GET("/", func(c echo.Context) error {
        // Return "Hello, World!" to the client
        return c.String(http.StatusOK, "Hello, World!")
    })

    // Start the server on port 8080
    e.Logger.Fatal(e.Start(":8080"))
}
