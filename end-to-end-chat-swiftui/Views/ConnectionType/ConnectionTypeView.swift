import SwiftUI

struct ConnectionTypeView: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  @State var isNavigateToChat = false

  var body: some View {
    VStack {

      Text("Hello, \(mainViewModel.username)!")

      NavigationLink(destination: NavigationViews.chatView, isActive: $isNavigateToChat) {
        Button(action: {
          isNavigateToChat = true
        }, label: { Text("Next") })
      }

    }
    .navigationBarTitle("Connection type")
  }
}
