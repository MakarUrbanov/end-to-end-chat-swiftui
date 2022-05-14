import SwiftUI

struct UserView: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  @State var username = ""
  @State var isShowingAlert = false
  @Environment(\.colorScheme) var colorScheme
  @State var isNavigateToConnectionTypeView = false

  var body: some View {
    VStack {
      SimpleTextField(text: $username, label: {
        Text("Username")
        .foregroundColor(.black.opacity(0.5))
      })
      .disableAutocorrection(true)
      .frame(maxWidth: .infinity)
      .padding()
      .foregroundColor(.black)
      .background(.white)
      .cornerRadius(8)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
        .stroke(colorScheme == .dark ? .black.opacity(0) : .black.opacity(0.2))
      }

      NavigationLink(destination: NavigationViews.connectionTypeView, isActive: $isNavigateToConnectionTypeView) {
        SimplePressableWrapper(content: {
          Text("Set user's info")
          .padding()
          .frame(maxWidth: .infinity)
          .background(.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
          .padding(.top)
        }, perform: {
          mainViewModel.setUserData(username: username) { isSuccess in
            if !isSuccess {
              isShowingAlert = true

              return
            }

            isNavigateToConnectionTypeView = true
          }
        })
      }
    }
    .padding(.horizontal)
    .alert(isPresented: $isShowingAlert) {
      Alert(title: Text("Error"),
        message: Text("Short username"),
        dismissButton: .default(Text("Cancel")))
    }
    .navigationBarTitle("Enter username")
  }
}
