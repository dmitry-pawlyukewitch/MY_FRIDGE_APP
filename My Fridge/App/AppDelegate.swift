import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - CoreDate

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyFridge")
        container.loadPersistentStores { (_, _) in
        }
        return container
    }()

    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            try? persistentContainer.viewContext.save() 
        }
    }
}
