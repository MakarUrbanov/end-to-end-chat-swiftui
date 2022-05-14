import Foundation

final class MainViewModel: ObservableObject {
  @Published var username = ""
  @Published var isAuth = false

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

  func exit() {
    isAuth = false
  }
}
