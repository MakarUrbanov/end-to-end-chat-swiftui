import Foundation

enum ChatWebSocketEvents: String, Encodable, Decodable {
  case join = "join"
  case create = "create"
  case leave = "leave"
  case disconnect = "disconnect"
  case message = "message"
  case typing = "typing"
  case stopTyping = "stopTyping"
}

struct ChatWebSocketMessage: Encodable, Decodable {
  var message: String?
  let event: ChatWebSocketEvents
  let hubId: String?
}
