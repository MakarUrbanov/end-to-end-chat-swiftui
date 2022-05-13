import SwiftUI

struct MainView: View {
  @StateObject var viewModel = MainViewModel()

  var body: some View {
    ZStack {
      switch viewModel.stage {
        case .userData:
          UserView()

        case .connectType:
          ConnectionTypeView()

        case .chat:
          ChatView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .environmentObject(viewModel)
  }
}
