package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

// Configuration holds server settings
type Configuration struct {
	Port    int
	Timeout time.Duration
}

// defaultConfig creates a default configuration
func defaultConfig() Configuration {
	return Configuration{
		Port:    8080,
		Timeout: 30 * time.Second,
	}
}

func main() {
	// Get configuration
	config := defaultConfig()

	if portEnv := os.Getenv("PORT"); portEnv != "" {
		if port, err := strconv.Atoi(portEnv); err == nil {
			config.Port = port
		} else {
			log.Printf("Invalid PORT: %s, using default: %d", portEnv, config.Port)
		}
	}

	// Create HTTP server
	server := &http.Server{
		Addr:         fmt.Sprintf(":%d", config.Port),
		ReadTimeout:  config.Timeout,
		WriteTimeout: config.Timeout,
		Handler:      http.HandlerFunc(handleRequest),
	}

	// Start server
	log.Printf("Starting server on port %d...", config.Port)
	if err := server.ListenAndServe(); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}

// handleRequest handles incoming HTTP requests
func handleRequest(w http.ResponseWriter, r *http.Request) {
	start := time.Now()
	defer func() {
		log.Printf("%s %s - %v", r.Method, r.URL.Path, time.Since(start))
	}()

	switch r.URL.Path {
	case "/":
		handleHome(w, r)
	case "/health":
		handleHealth(w, r)
	default:
		http.NotFound(w, r)
	}
}

// handleHome handles requests to the home page
func handleHome(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Welcome to the Go Example Server\n")
}

// handleHealth handles health check requests
func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"status":"ok","timestamp":"%s"}`, time.Now().Format(time.RFC3339))
}

// This comment demonstrates folding capabilities in Go
// The following is a utility function not used in the example
/*
func processData(data []byte) ([]byte, error) {
	if len(data) == 0 {
		return nil, fmt.Errorf("empty data")
	}
	
	result := make([]byte, len(data))
	for i, b := range data {
		result[i] = b + 1
	}
	
	return result, nil
}
*/