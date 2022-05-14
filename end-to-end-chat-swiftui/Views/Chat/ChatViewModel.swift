import Foundation
import Combine

struct ChatMessage: Encodable, Decodable {
  let message: String
}

class ChatViewModelWebSocket {
  private var webSocketTask: URLSessionWebSocketTask?
  @Published var isConnected = false
  @Published var webSocketUrl = "ws://192.168.0.62:5123"
  @Published var lastMessage = "nil"

  fileprivate func connect() async {
    guard let url = URL(string: webSocketUrl) else {
      return
    }
    webSocketTask = URLSession.shared.webSocketTask(with: url)
    webSocketTask?.receive(completionHandler: onReceive)
    webSocketTask?.resume()
    await self.PING()
  }

  private func PING() async {
    do {
      let ping = ChatMessage(message: "Ping")
      guard let json = try? JSONEncoder().encode(ping) else {
        return
      }

      guard let stringJSON = String(data: json, encoding: .utf8) else {
        return
      }

      try await webSocketTask?.send(.string(stringJSON))
      isConnected = true
      print("PING")
    } catch {
      print("ERROR PING: \(error)")
    }
  }

  fileprivate func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
    if case .success(let message) = incoming {
      isConnected = true
      onMessage(message: message)
    } else if case .failure(let error) = incoming {
      isConnected = false
      reconnect()
      print("ERROR onReceive: \(error)")
    }
  }

  fileprivate func onMessage(message: URLSessionWebSocketTask.Message) {
    if case .string(let text) = message {
      guard let data = text.data(using: .utf8) else {
        return
      }

      let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: data)

      DispatchQueue.main.async {
        self.lastMessage = chatMessage?.message ?? "failed"
      }
    }

    webSocketTask?.receive(completionHandler: onReceive)
  }

  fileprivate func reconnect() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
      Task {
        await self.connect()
      }
    }
  }

  func sendMessage(text: String) async {
    do {
      let message = ChatMessage(message: text)
      let json = try JSONEncoder().encode(message)
      guard let jsonString = String(data: json, encoding: .utf8) else {
        return
      }

      try await webSocketTask?.send(.string(jsonString))
    } catch {
      print("ERROR sendMessage: \(error)")
    }
  }

  fileprivate func disconnect() {
    isConnected = false
    webSocketTask?.cancel(with: .normalClosure, reason: nil)
    print("disconnect")
  }

  deinit {
    disconnect()
  }
}

final class ChatViewModel: ChatViewModelWebSocket, ObservableObject {
  func onAppear() async {
    await super.connect()
  }

  func onDisappear(callback: () -> Void) {
    super.disconnect()
    callback()
  }
}
