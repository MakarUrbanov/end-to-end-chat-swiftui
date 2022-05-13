import Foundation

enum Stages {
  case userData
  case connectType
  case chat
}

final class MainViewModel: ObservableObject {
  @Published var username = ""
  @Published var isAuth = false
  @Published var stage: Stages = .userData

  func setUserData(username: String, completionHandler: @escaping (Bool) -> Void) {
    switch true {
      case username.count < 3:
        completionHandler(false)

        return

      default:
        stage = .connectType
        completionHandler(true)
    }

    self.username = username
    isAuth = true
  }

  func exit() {
    isAuth = false
    stage = .userData
  }
}
