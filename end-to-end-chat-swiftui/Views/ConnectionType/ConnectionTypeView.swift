import SwiftUI

struct ConnectionTypeView: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  @State var isNavigateToChat = false

  var body: some View {
    VStack {

      NavigationLink(destination: NavigationViews.chatView, isActive: $isNavigateToChat) {
        SimplePressableWrapper(content: {
          Text("Create a new chat")
          .frame(maxWidth: .infinity)
          .padding()
          .background(.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
        }, perform: {
          mainViewModel.connectionType = .create
          isNavigateToChat = true
        })
      }

      NavigationLink(destination: NavigationViews.chatView, isActive: $isNavigateToChat) {
        SimplePressableWrapper(content: {
          Text("Join to chat")
          .frame(maxWidth: .infinity)
          .padding()
          .background(.blue.opacity(0.8))
          .foregroundColor(.white)
          .cornerRadius(8)
        }, perform: {
          mainViewModel.connectionType = .join
          isNavigateToChat = true
        })
        .padding(.top)
      }

    }
    .padding(.horizontal)
    .navigationBarTitle("Hello, \(mainViewModel.username)!")
  }
}
