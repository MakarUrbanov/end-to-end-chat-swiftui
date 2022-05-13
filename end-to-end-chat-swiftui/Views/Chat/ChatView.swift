import Foundation
import SwiftUI

struct ChatView: View {
  @StateObject var viewModel = ChatViewModel()
  @EnvironmentObject var mainViewModel: MainViewModel
  @State var message = ""

  var body: some View {
    VStack {
      Text("Is connected: \(String(viewModel.isConnected))")
      .padding(.bottom)

      Text("Last message: \(viewModel.lastMessage)")
      .padding(.bottom)

      Button(action: {
        Task {
          await viewModel.sendMessage(text: message)
        }
      }, label: { Text("SEND") })
      .padding(.bottom)

      Button(action: {
        viewModel.onDisappear(callback: mainViewModel.exit)
      }, label: { Text("EXIT") })
      .padding(.vertical)

    }
    .onAppear {
      Task {
        await viewModel.onAppear()
      }
    }
  }
}
