import Foundation

class WebSocket: ObservableObject {
  private var webSocketTask: URLSessionWebSocketTask?
  private var webSocketUrl: String

  var onMessageHandler: (ChatWebSocketMessage) -> Void
  var isConnectedHandler: (Bool) -> Void

  init(
    url: String,
    onMessageHandler: @escaping (ChatWebSocketMessage) -> Void,
    isConnectedHandler: @escaping (Bool) -> Void
  ) {
    self.webSocketUrl = url
    self.onMessageHandler = onMessageHandler
    self.isConnectedHandler = isConnectedHandler
  }

  func connect(onComplete: @escaping () -> Void = {
  }) {
    guard let url = URL(string: webSocketUrl) else {
      return
    }

    webSocketTask = URLSession.shared.webSocketTask(with: url)
    webSocketTask?.receive(completionHandler: onReceive)
    webSocketTask?.resume()

    onComplete()
  }

  func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
    if case .success(let message) = incoming {
      isConnectedHandler(true)
      onMessage(message: message)
    } else if case .failure(let error) = incoming {
      isConnectedHandler(false)
      reconnect()
      print("ERROR onReceive: \(error)")
    }
  }

  func onMessage(message: URLSessionWebSocketTask.Message) {
    if case .string(let text) = message {
      guard let data = text.data(using: .utf8) else {
        return
      }

      guard let chatMessage = try? JSONDecoder().decode(ChatWebSocketMessage.self, from: data) else {
        print("ERROR onMessage decode")
        return
      }

      onMessageHandler(chatMessage)
    }

    webSocketTask?.receive(completionHandler: onReceive)
  }

  func sendMessage(message: ChatWebSocketMessage) async {
    do {
      let json = try JSONEncoder().encode(message)
      guard let jsonString = String(data: json, encoding: .utf8) else {
        return
      }

      try await webSocketTask?.send(.string(jsonString))
    } catch {
      print("ERROR sendMessage: \(error)")
    }
  }

  func reconnect() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.connect()
    }
  }

  func disconnect() {
    isConnectedHandler(false)
    webSocketTask?.cancel(with: .normalClosure, reason: nil)
    print("disconnect")
  }

  deinit {
    disconnect()
  }
}
