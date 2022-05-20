import SwiftUI

struct ChatView: View {
  @StateObject var viewModel = ChatViewModel()
  @EnvironmentObject var mainViewModel: MainViewModel
  @State var message = ""
  @State var isPresentSheet = false

  var body: some View {
    VStack {
      ScrollView {
        ForEach(viewModel.messages) { message in
          Text(message.message.message ?? "404 message")
        }
      }


      Text("Is connected: \(String(viewModel.isConnected))")
      .padding(.bottom)

      SimpleTextField(text: $message, label: { Text("Enter message") })

      Button(action: {
        Task {
          let message = ChatWebSocketMessage(message: message, event: .message, hubId: viewModel.hubId)
          await viewModel.webSocket.sendMessage(message: message)
        }
      }, label: {
        Text("Send message")
      })

    }
    .onAppear {
      print("onAppear")
      viewModel.onAppear(connectionType: mainViewModel.connectionType) { isPresentSheet in
        self.isPresentSheet = isPresentSheet
      }
    }
    .onDisappear {
      viewModel.onDisappear()
    }
    .sheet(isPresented: $isPresentSheet) {
      HubIdSheet()
      .environmentObject(viewModel)
    }
  }
}
