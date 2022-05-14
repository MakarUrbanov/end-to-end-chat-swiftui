import SwiftUI

struct SimplePressableWrapper<Content: View>: View {
  var content: Content
  var activeOpacity: Double
  @State var isPressed = false
  var perform: () -> Void

  init(activeOpacity: Double = 0.8, @ViewBuilder content: () -> Content, perform: @escaping () -> Void) {
    self.content = content()
    self.activeOpacity = activeOpacity
    self.perform = perform
  }

  var body: some View {
    content
    .contentShape(Rectangle())
    .onTapGesture {
      perform()
    }
    .onLongPressGesture(minimumDuration: 3,
      maximumDistance: 10,
      perform: {
      }, onPressingChanged: { bool in
      isPressed = bool
    })
    .opacity(isPressed ? 0.8 : 1)
  }
}
