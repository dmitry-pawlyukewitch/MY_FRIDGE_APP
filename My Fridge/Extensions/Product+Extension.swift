import Foundation

extension Product {

    var isExpired: Bool {
        expirationDate < Date()
    }
}
