import Foundation

extension Dictionary where Key == String, Value == Any {
  init(builder: StealthyPropertyBuilder) {
    let values: [CFString: Any?] = [
      kSecAttrAccount: builder.account,
      kSecValueData: builder.data,
      kSecAttrAccessGroup: builder.accessGroup,
      kSecAttrCreationDate: builder.createdAt,
      kSecAttrModificationDate: builder.modifiedAt,
      kSecAttrDescription: builder.description,
      kSecAttrType: builder.type,
      kSecAttrLabel: builder.label,
      kSecAttrServer: builder.server,
      kSecAttrProtocol: builder.protocol?.cfValue,
      kSecAttrPort: builder.port,
      kSecAttrPath: builder.path,
      kSecAttrSynchronizable: builder.isSynchronizable.cfValue,
      kSecAttrService: builder.service
    ]

    self = Dictionary(uniqueKeysWithValues: values.compactMap { pair in
      pair.value.map { (pair.key as String, $0) }
    })
  }
}
