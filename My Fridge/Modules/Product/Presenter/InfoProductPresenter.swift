import UIKit

class InfoProductPresenter: BasePresenter {

    private var productView: ProductViewControllerProtocol? {
        view as? ProductViewControllerProtocol
    }
    private let product: Product
    private let toolbarButtonComplition: () -> Void

    private var productCellTypes: [ProductCellType] {
        [.name, .expirationDate]
    }

    init(view: ProductViewControllerProtocol, product: Product, toolbarButtonComplition: @escaping () -> Void) {
        self.product = product
        self.toolbarButtonComplition = toolbarButtonComplition

        super.init(view: view)
    }
}

// MARK: - ProductPresenterProtocol

extension InfoProductPresenter: ProductPresenterProtocol {

    var viewTitle: String {
        "Product.ViewTitle.Info".localized
    }

    var numberOfProductCellTypes: Int {
        productCellTypes.count
    }

    var productNameViewModel: ProductNameViewModel {
        ProductNameViewModel(name: product.name, isEditingEnabled: false)
    }

    var productExpirationDateViewModel: ProductExpirationDateViewModel {
        ProductExpirationDateViewModel(date: product.expirationDate, valueTextColor: .label)
    }

    var productDatePickerViewModel: ProductDatePickerViewModel {
        ProductDatePickerViewModel(date: product.expirationDate)
    }

    var rightBarButtonSystemItem: UIBarButtonItem.SystemItem? {
       nil
    }

    var productToolbarButtonViewModel: ProductToolbarButtonViewModel? {
        product.isExpired ?
            ProductToolbarButtonViewModel(title: "Product.ToolbarButtonTitle.Delete".localized, color: .red) :
            ProductToolbarButtonViewModel(title: "Product.ToolbarButtonTitle.Eat".localized, color: .link)
    }

    var isRightBarButtonEnabled: Bool {
        !product.name.isEmpty
    }

    func productCellType(at index: Int) -> ProductCellType {
        productCellTypes[index]
    }

    func closeAction() {
        AppRouter.shared.dismissPresentedNavigationController(animated: true)
    }

    func rightBarButtonAction() {
    }

    func toolbarButtonAction() {
        AppRouter.shared.dismissPresentedNavigationController(animated: true)
        toolbarButtonComplition()
    }

    func didChangeName(_ name: String) {
    }

    func didChangeExpirationDate(_ expirationDate: Date) {
    }

    func didTapExpirationDateCell() {
    }
}
