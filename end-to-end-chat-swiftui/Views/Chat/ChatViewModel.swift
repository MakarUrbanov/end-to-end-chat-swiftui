import Foundation

struct ChatWebSocketMessageTest: Identifiable {
  let id = UUID().uuidString
  let message: ChatWebSocketMessage
}

final class ChatViewModel: ObservableObject {
  @Published var hubId = ""
  @Published var isConnected = false
  @Published var messages: [ChatWebSocketMessageTest] = []
  private(set) lazy var webSocket: WebSocket = WebSocket(
    url: "ws://localhost:5123",
    onMessageHandler: chatMessageHandler,
    isConnectedHandler: isConnectedHandler
  )

  func chatMessageHandler(message: ChatWebSocketMessage) {
    print("ChatMessageHandler: \(message)")

    switch message.event {
      case .create:
        print("create")
        self.hubId = message.hubId ?? ""
        return

      case .join:
        print("join")
//
//      case .leave:
//
//      case .disconnect:
//
      case .message:
        let renderMessage = ChatWebSocketMessageTest(message: message)
        messages += [renderMessage]
        return
//
//      case .typing:
//
//      case .stopTyping:

      default:
        print("")
    }
  }

  private func isConnectedHandler(isConnected: Bool) {
    self.isConnected = isConnected
  }

  func onAppear(connectionType: ConnectionTypeKeys, isPresentSheet: @escaping (Bool) -> Void) {
    switch connectionType {
      case .join:
        isPresentSheet(true)
        return

      case .create:
        isPresentSheet(true)
        self.createHub()
    }
  }

  func onDisappear(callback: () -> Void = {
  }) {
    webSocket.disconnect()
    callback()
  }

  func createHub() {
    webSocket.connect(onComplete: { [self] in
      Task {
        let message = ChatWebSocketMessage(event: .create, hubId: "")
        await webSocket.sendMessage(message: message)
      }
    })
  }

  func joinToHub() {
    webSocket.connect(onComplete: { [self] in
      Task {
        let message = ChatWebSocketMessage(event: .join, hubId: self.hubId)
        await webSocket.sendMessage(message: message)
      }
    })
  }
}
