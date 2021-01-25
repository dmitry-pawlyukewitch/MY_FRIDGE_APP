import UIKit

class AddProductPresenter: BasePresenter {

    private var productView: ProductViewControllerProtocol? {
        view as? ProductViewControllerProtocol
    }

    private let product: Product
    private let saveCompletion: (Product) -> Void
    private var isDatePickerShowing = false
    private var productCellTypes: [ProductCellType] {
        isDatePickerShowing ? [.name, .expirationDate, .datePicker] : [.name, .expirationDate]
    }

    init(view: ProductViewControllerProtocol, saveCompletion: @escaping (Product) -> Void) {
        product = Product(name: "", expirationDate: Date())
        self.saveCompletion = saveCompletion

        super.init(view: view)
    }

    // MARK: - Private

    private func closeModule() {
        AppRouter.shared.dismissPresentedNavigationController(animated: true)
    }

    private func closeIfNeeded() {
        product.name.isEmpty ?
            closeModule() :
            AppRouter.shared.showDiscardProductChangesAlert { [weak self] in
                self?.closeModule()
            }
    }
}

// MARK: - ProductPresenterProtocol

extension AddProductPresenter: ProductPresenterProtocol {

    var viewTitle: String {
        "Product.ViewTitle.Add".localized
    }

    var numberOfProductCellTypes: Int {
        productCellTypes.count
    }

    var productNameViewModel: ProductNameViewModel {
        ProductNameViewModel(name: product.name, isEditingEnabled: true)
    }

    var productExpirationDateViewModel: ProductExpirationDateViewModel {
        ProductExpirationDateViewModel(date: product.expirationDate,
                                       valueTextColor: isDatePickerShowing ? .link : .label)
    }

    var productDatePickerViewModel: ProductDatePickerViewModel {
        ProductDatePickerViewModel(date: product.expirationDate)
    }

    var rightBarButtonSystemItem: UIBarButtonItem.SystemItem? {
        .save
    }

    var productToolbarButtonViewModel: ProductToolbarButtonViewModel? {
        nil
    }

    var isRightBarButtonEnabled: Bool {
        !product.name.isEmpty
    }

    func productCellType(at index: Int) -> ProductCellType {
        productCellTypes[index]
    }

    func closeAction() {
        closeIfNeeded()
    }

    func rightBarButtonAction() {
        saveCompletion(product)
        closeModule()
    }

    func toolbarButtonAction() {
    }

    func didChangeName(_ name: String) {
        product.name = name
    }

    func didChangeExpirationDate(_ expirationDate: Date) {
        product.expirationDate = expirationDate
        guard let expirationDateCellIndex = productCellTypes.firstIndex(of: .expirationDate) else {
            return
        }

        productView?.reloadRow(at: expirationDateCellIndex)
    }

    func didTapExpirationDateCell() {
        let datePickerCellIndexBeforeDeleting = productCellTypes.firstIndex(of: .datePicker)
        isDatePickerShowing.toggle()
        let datePickerCellIndexAfterInserting = productCellTypes.firstIndex(of: .datePicker)
        guard let datePickerCellIndex = datePickerCellIndexBeforeDeleting ?? datePickerCellIndexAfterInserting,
              let expirationDateCellIndex = productCellTypes.firstIndex(of: .expirationDate) else {
            return
        }

        isDatePickerShowing ?
            productView?.insertRow(at: datePickerCellIndex) :
            productView?.deleteRow(at: datePickerCellIndex)
        productView?.reloadRow(at: expirationDateCellIndex)
    }
}
