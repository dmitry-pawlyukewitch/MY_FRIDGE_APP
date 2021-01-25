import Foundation

protocol MyFridgeViewControllerProtocol: BaseViewControllerProtocol {

    func deleteRow(at index: Int, in section: Int)
    func deleteSection(at index: Int)
    func reloadData()
}
