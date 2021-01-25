import UIKit

// MARK: - NibNamed

extension UIView: NibNamed {

    static var nibName: String {
        String(describing: self)
    }
}
