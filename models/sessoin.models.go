package models

import "github.com/gorilla/websocket"

type Message struct {
	Username string          `json:"username"`
	Message  string          `json:"message"`
	RoomId   string          `json:"roomId"`
	Sender   *websocket.Conn `json:"-"`
}

type Room struct {
	Clients   map[*websocket.Conn]bool
	Broadcast chan Message
}
