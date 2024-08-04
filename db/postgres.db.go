package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var pool *pgxpool.Pool

// InitDB initializes the database connection pool.
func InitDB() error {
	dsn := os.Getenv("DATABASE_URL") // Ensure this is set in your environment
	config, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return fmt.Errorf("unable to parse database URL: %v", err)
	}

	pool, err = pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return fmt.Errorf("unable to connect to database: %v", err)
	}

	fmt.Println("Connected to database successfully 🎉")

	return nil
}

// GetDB returns the connection pool.
func GetDB() *pgxpool.Pool {
	return pool
}

// CloseDB closes the database connection pool.
func CloseDB() {
	if pool != nil {
		pool.Close()
	}
}
