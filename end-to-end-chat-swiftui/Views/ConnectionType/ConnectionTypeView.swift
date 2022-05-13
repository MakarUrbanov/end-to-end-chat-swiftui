import Foundation
import SwiftUI

struct ConnectionTypeView: View {
  @EnvironmentObject var mainViewModel: MainViewModel

  var body: some View {
    NavigationView {
      VStack {
        Button(action: {
          mainViewModel.stage = .chat
        }, label: { Text("Next") })
      }
      .navigationBarTitle("Connection type")
    }
  }
}
