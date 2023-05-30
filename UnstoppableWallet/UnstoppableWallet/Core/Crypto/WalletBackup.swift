import Foundation

class WalletBackup: Codable {
    let crypto: WalletBackupCrypto
    let id: String
    let type: AccountType.Abstract
    let version: Int
    let timestamp: TimeInterval?

    enum CodingKeys: String, CodingKey {
        case crypto
        case id
        case type
        case version
        case timestamp
    }

    init(crypto: WalletBackupCrypto, id: String, type: AccountType.Abstract, version: Int, timestamp: TimeInterval) {
        self.crypto = crypto
        self.id = id
        self.type = type
        self.version = version
        self.timestamp = timestamp.rounded()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        crypto = try container.decode(WalletBackupCrypto.self, forKey: .crypto)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(AccountType.Abstract.self, forKey: .type)
        version = try container.decode(Int.self, forKey: .version)
        timestamp = try? container.decode(TimeInterval.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(crypto, forKey: .crypto)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(version, forKey: .version)
        try container.encode(timestamp, forKey: .timestamp)
    }

}
