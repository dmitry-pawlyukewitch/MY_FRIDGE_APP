import Foundation
import CoreData

extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var expirationDate: Date?
    @NSManaged public var name: String?
}
