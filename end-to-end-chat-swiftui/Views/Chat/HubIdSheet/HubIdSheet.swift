import SwiftUI
import Foundation

struct HubIdSheet: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  @EnvironmentObject var chatViewModel: ChatViewModel
  @State var hubId = ""

  @Environment(\.presentationMode) var presentationMode

  func copyToClipboard() {
    UIPasteboard.general.string = chatViewModel.hubId
  }

  var body: some View {
    VStack {
      if mainViewModel.connectionType == .join {
        VStack {
          SimpleTextField(text: $hubId, label: {
            Text("Enter chat id")
          })

          Button(action: {
            chatViewModel.hubId = hubId
            chatViewModel.joinToHub()

            presentationMode.wrappedValue.dismiss()
          }, label: {
            Text("Join")
          })
        }
      } else {
        VStack {
          Text("Chat id:")
          HStack {
            Text(chatViewModel.hubId)

            Button(action: {
              copyToClipboard()
            }, label: {
              Image(systemName: "doc.on.doc")
              .resizable(resizingMode: .tile)
              .scaledToFit()
              .frame(width: 30, height: 30)
            })
          }
        }
      }
    }
    .padding(.horizontal)
  }
}
