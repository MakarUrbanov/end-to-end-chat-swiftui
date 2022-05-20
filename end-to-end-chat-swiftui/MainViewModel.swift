import Foundation

enum ConnectionTypeKeys {
  case join
  case create
}

final class MainViewModel: ObservableObject {
  @Published var username = ""
  @Published var isAuth = false
  @Published var connectionType: ConnectionTypeKeys = .create

  func setUserData(username: String, completionHandler: @escaping (Bool) -> Void) {
    switch true {
      case username.count < 3:
        completionHandler(false)

        return

      default:
        completionHandler(true)
    }

    self.username = username
    isAuth = true
  }
}
