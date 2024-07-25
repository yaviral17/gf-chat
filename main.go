package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"github.com/joho/godotenv"
	"github.com/yaviral17/gf-chat/models"
)

var upgrade = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

// Global map for rooms
var rooms = make(map[string]*models.Room)

func handleConnections(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	roomID := vars["room_id"] // Ensure this matches the route variable

	// Upgrade initial GET request to a WebSocket
	ws, err := upgrade.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Upgrade error:", err)
		return
	}
	defer ws.Close()

	if rooms[roomID] == nil {
		rooms[roomID] = &models.Room{
			Clients:   make(map[*websocket.Conn]bool),
			Broadcast: make(chan models.Message),
		}
		go handleMessages(roomID)
	}
	room := rooms[roomID]
	room.Clients[ws] = true

	for {
		// Read in a new message as JSON and map it to a Message object
		var msg models.Message
		err := ws.ReadJSON(&msg)
		// log.Println(msg)
		if err != nil {
			if websocket.IsCloseError(err, websocket.CloseNormalClosure, websocket.CloseGoingAway) {
				log.Println("WebSocket closed:", err)
			} else {
				log.Println("Read error:", err)
			}
			delete(room.Clients, ws)
			break
		}
		msg.Sender = ws
		msg.RoomId = roomID

		// Send the new message to the broadcast channel
		room.Broadcast <- msg
	}
}

func handleMessages(roomID string) {
	room := rooms[roomID]
	for {
		msg := <-room.Broadcast
		for client := range room.Clients {

			if client != msg.Sender {
				// Check if the client is not the sender
				err := client.WriteJSON(msg)
				if err != nil {
					log.Printf("Write error: %v", err)
					client.Close()
					delete(room.Clients, client)
				}
			}
		}
	}
}

func main() {
	err := godotenv.Load()
	// if err != nil {
	// 	log.Fatalf("Error loading .env file")
	// }

	port := os.Getenv("PORT")
	welcome := os.Getenv("WELCOME")
	if welcome == "" {
		welcome = "Welcome to GF Chat"

	}
	if port == "" {
		port = "3456"
	}

	log.Println("PORT: ", port)
	log.Println("WELCOME: ", welcome)

	r := mux.NewRouter()

	r.HandleFunc("/api/chat/{room_id}", handleConnections)
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(welcome))
	})

	fmt.Println("HTTP server started on :" + port)
	err = http.ListenAndServe("0.0.0.0:"+port, r)
	if err != nil {
		log.Fatal(err)
	}
}
