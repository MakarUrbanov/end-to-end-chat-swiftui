import Foundation
import SwiftUI

struct SimpleTextField<Label: View>: View {
  @Binding var text: String
  let label: () -> Label

  var body: some View {
    TextField(text: $text, label: { Text("") })
    .background(alignment: .leading) {
      if text.isEmpty {
        label()
      }
    }
  }
}
