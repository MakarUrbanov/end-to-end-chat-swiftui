import Foundation
import SwiftUI

struct UserView: View {
  @EnvironmentObject var viewModel: MainViewModel
  @State var username = ""
  @State var isShowingAlert = false
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    NavigationView {
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

        SimplePressableWrapper(content: {
          Text("Set user's info")
          .padding()
          .frame(maxWidth: .infinity)
          .background(.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
          .padding(.top)
        }, perform: {
          viewModel.setUserData(username: username) { isSuccess in
            if !isSuccess {
              isShowingAlert = true
            }
          }
        })
      }
      .padding(.horizontal)
      .navigationBarTitle("Enter username")
    }
    .alert(isPresented: $isShowingAlert) {
      Alert(title: Text("Error"),
        message: Text("Short username"),
        dismissButton: .default(Text("Cancel")))
    }
  }
}
