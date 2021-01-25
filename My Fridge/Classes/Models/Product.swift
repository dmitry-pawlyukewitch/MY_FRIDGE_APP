import Foundation

class Product: NSObject {

    var name: String
    var expirationDate: Date

    init(name: String, expirationDate: Date) {
        self.name = name
        self.expirationDate = expirationDate
    }
}
