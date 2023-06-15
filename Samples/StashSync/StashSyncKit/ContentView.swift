import StealthyStash
import SwiftUI

public struct ContentView: View {
  public init(
    oldGeneric: GenericPasswordItem? = nil,
    oldInternet: InternetPasswordItem? = nil,
    generic: String = "",
    internet: String = "",
    errorDescription: String? = nil
  ) {
    self.oldGeneric = oldGeneric
    self.oldInternet = oldInternet
    self.generic = generic
    self.internet = internet
    self.errorDescription = errorDescription
  }

  static let defaultName = "StashSync"
  let repository = KeychainRepository(
    defaultServiceName: "StashSync",
    defaultServerName: "StashSync",
    defaultAccessGroup: "MLT7M394S7.com.brightdigit.StashSync"
  )

  @State var oldGeneric: GenericPasswordItem?
  @State var oldInternet: InternetPasswordItem?

  @State var generic: String = ""
  @State var internet: String = ""
  @State var errorDescription: String?

  public func load() {
    do {
      if let genericItem = try repository.query(TypeQuery(type: .generic)).first {
        oldGeneric = genericItem.property as? GenericPasswordItem
        generic = String(data: genericItem.data, encoding: .utf8) ?? ""
      }

      if let internetItem = try repository.query(TypeQuery(type: .internet)).first {
        oldInternet = internetItem.property as? InternetPasswordItem
        internet = String(data: internetItem.data, encoding: .utf8) ?? ""
      }
    } catch {
      errorDescription = error.localizedDescription
    }
  }

  func save() {
    let newGeneric = GenericPasswordItem(
      account: Self.defaultName,
      data: generic.data(using: .utf8)!,
      isSynchronizable: .enabled
    )

    let newInternet = InternetPasswordItem(
      account: Self.defaultName,
      data: internet.data(using: .utf8)!,
      isSynchronizable: .enabled
    )

    do {
      if let oldGeneric {
        try repository.update(newGeneric, from: oldGeneric)
      } else {
        try repository.create(.init(property: newGeneric))
      }
      oldGeneric = newGeneric
      if let oldInternet {
        try repository.update(newInternet, from: oldInternet)
      } else {
        try repository.create(.init(property: newInternet))
      }
      oldInternet = newInternet
    } catch {
      errorDescription = error.localizedDescription
    }
  }

  #if os(watchOS)
    let spacing = 0.0
  #else
    let spacing = 12.0
  #endif

  #if os(watchOS)
    let buttonStyle = BorderedProminentButtonStyle.borderedProminent
  #else
    let buttonStyle = DefaultButtonStyle.automatic

  #endif

  public var body: some View {
    VStack(spacing: spacing) {
      TextField("Internet", text: self.$internet)
      TextField("Generic", text: self.$generic)
      HStack {
        Button("Load") {
          self.load()
        }.buttonStyle(buttonStyle)
        Spacer()
        Button("Save") {
          self.save()
        }.buttonStyle(buttonStyle)
      }
      if let errorDescription = self.errorDescription {
        Button(action: {
          self.errorDescription = nil
        }, label: {
          Text(errorDescription)
        }).buttonStyle(.borderless)
      }
    }
    .padding().onAppear {
      self.load()
    }
  }
}

#Preview {
  ContentView(errorDescription: "Test Error")
}
