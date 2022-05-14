import SwiftUI

struct MainView: View {
  @StateObject var viewModel = MainViewModel()

  var body: some View {
    NavigationView {
      UserView()
    }
    .navigationViewStyle(.stack)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .environmentObject(viewModel)
  }
}
