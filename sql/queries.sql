-- name: GetUserByID :one
SELECT * from users WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * from users WHERE email = $1 LIMIT 1;

-- name: CreateUser :one
INSERT INTO users (id, first_name, last_name, email, phone, created_at) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;

-- name: CreateMessage :one
INSERT INTO messages (id, sender, receiver, room_id, body, created_at) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;

-- name: CreateRoom :one
INSERT INTO rooms (id, room_name, created_at) VALUES ($1, $2, $3) RETURNING *;

-- name: CreateRoomMembership :one
INSERT INTO room_memberships (id, user_id, room_id, joined_at, left_at) VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: GetMessagesByRoomID :many
SELECT * from messages WHERE room_id = $1;

-- name: GetRoomByID :one
SELECT * from rooms WHERE id = $1 LIMIT 1;

-- name: GetRoomMembershipsByRoomID :many
SELECT * from room_memberships WHERE room_id = $1;

-- name: GetRoomMembershipsByUserID :many
SELECT * from room_memberships WHERE user_id = $1;

-- name: GetRoomsByUserID :many
SELECT rooms.* from rooms JOIN room_memberships ON rooms.id = room_memberships.room_id WHERE room_memberships.user_id = $1;

-- name: GetRoomMembershipByUserIDAndRoomID :one
SELECT * from room_memberships WHERE user_id = $1 AND room_id = $2 LIMIT 1;

-- name: UpdateRoomMembershipLeftAt :one
UPDATE room_memberships SET left_at = $1 WHERE user_id = $2 AND room_id = $3 RETURNING *;

-- name: GetMessagesBySenderAndReceiver :many
SELECT * from messages WHERE sender = $1 AND receiver = $2;

-- name: GetMessagesBySenderAndReceiverAndRoomID :many
SELECT * from messages WHERE sender = $1 AND receiver = $2 AND room_id = $3;

-- name: GetMessagesBySenderAndRoomID :many
SELECT * from messages WHERE sender = $1 AND room_id = $2;

-- name: UpdateUser :one
UPDATE users SET first_name = $1, last_name = $2, email = $3, phone = $4 WHERE id = $5 RETURNING *;

-- name: UpdateRoom :one
UPDATE rooms SET room_name = $1 WHERE id = $2 RETURNING *;

-- name: DeleteRoomMembership :one
DELETE FROM room_memberships WHERE user_id = $1 AND room_id = $2 RETURNING *;

-- name: DeleteRoom :one
DELETE FROM rooms WHERE id = $1 RETURNING *;

-- name: DeleteMessage :one
DELETE FROM messages WHERE id = $1 RETURNING *;

-- name: DeleteUser :one
DELETE FROM users WHERE id = $1 RETURNING *;

