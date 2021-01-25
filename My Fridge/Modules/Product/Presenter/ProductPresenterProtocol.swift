import UIKit

enum ProductCellType {
    case name
    case expirationDate
    case datePicker
}

protocol ProductPresenterProtocol: BasePresenterProtocol {

    var viewTitle: String { get }
    var numberOfProductCellTypes: Int { get }
    var productNameViewModel: ProductNameViewModel { get }
    var productExpirationDateViewModel: ProductExpirationDateViewModel { get }
    var productDatePickerViewModel: ProductDatePickerViewModel { get }
    var rightBarButtonSystemItem: UIBarButtonItem.SystemItem? { get }
    var productToolbarButtonViewModel: ProductToolbarButtonViewModel? { get }
    var isRightBarButtonEnabled: Bool { get }
    func productCellType(at index: Int) -> ProductCellType
    func closeAction()
    func rightBarButtonAction()
    func toolbarButtonAction()
    func didChangeName(_ name: String)
    func didChangeExpirationDate(_ expirationDate: Date)
    func didTapExpirationDateCell()
}
