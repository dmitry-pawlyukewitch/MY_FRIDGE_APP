import UIKit

protocol ProductViewControllerProtocol: BaseViewControllerProtocol {

    func reloadRow(at index: Int)
    func insertRow(at index: Int)
    func deleteRow(at index: Int)
}
