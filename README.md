
# GF-Chat (Go Flutter Chat)

A room based chat backend made for learning working with websockets and intigration of that with flutter 


## API Reference

### Set .env

> `PORT` your custom port number<br>
> `WELCOME` a welcome message which will be printed when visited at `http://{host_url}/`

#### Get all items
> Already deployed one
```
  Websocket wss://gf-chat-production.up.railway.app/api/chat/{room_id}
```
or

> Running on localhost
 ```  
 Websocket wss://localhost:{PORT}/api/chat/{room_id}
 ```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `room_id` | `string` | **Required**. Room Id  |


