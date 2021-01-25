import UIKit

class ProductViewController: BaseViewController {

    private var productPresenter: ProductPresenterProtocol? {
        presenter as? ProductPresenterProtocol
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        productPresenter?.viewDidLoad()
    }

    // MARK: - Actions

    @objc
    private func leftBarButtonAction() {
        productPresenter?.closeAction()
    }

    @objc
    private func rightBarButtonAction() {
        productPresenter?.rightBarButtonAction()
    }

    @objc
    private func toolbarButtonAction() {
        productPresenter?.toolbarButtonAction()
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ProductNameTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: ProductNameTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ProductExpirationDateTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: ProductExpirationDateTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ProductDatePickerTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: ProductDatePickerTableViewCell.reuseIdentifier)
    }

    private func reuseIdentifier(at index: Int) -> String {
        guard let productCellType = productPresenter?.productCellType(at: index) else {
            return ""
        }

        switch productCellType {
        case .name:
            return ProductNameTableViewCell.reuseIdentifier
        case .expirationDate:
            return ProductExpirationDateTableViewCell.reuseIdentifier
        case .datePicker:
            return ProductDatePickerTableViewCell.reuseIdentifier
        }
    }

    private func setup(_ cell: UITableViewCell, at index: Int) {
        guard let productCellType = productPresenter?.productCellType(at: index) else {
            return
        }

        switch productCellType {
        case .name:
            setupProductNameCell(cell)
        case .expirationDate:
            setupProductExpirationDateCell(cell)
        case .datePicker:
            setupProductDatePickerCell(cell)
        }
    }

    private func setupProductNameCell(_ cell: UITableViewCell) {
        guard let productNameCell = cell as? ProductNameTableViewCell,
              let productNameViewModel = productPresenter?.productNameViewModel else {
            return
        }

        productNameCell.setup(with: productNameViewModel)
        productNameCell.delegate = self
    }

    private func setupProductExpirationDateCell(_ cell: UITableViewCell) {
        guard let productExpirationDateCell = cell as? ProductExpirationDateTableViewCell,
              let productExpirationDateViewModel = productPresenter?.productExpirationDateViewModel else {
            return
        }

        productExpirationDateCell.setup(with: productExpirationDateViewModel)
    }

    private func setupProductDatePickerCell(_ cell: UITableViewCell) {
        guard let productDatePickerCell = cell as? ProductDatePickerTableViewCell,
              let productDatePickerViewModel = productPresenter?.productDatePickerViewModel else {
            return
        }

        productDatePickerCell.setup(with: productDatePickerViewModel)
        productDatePickerCell.delegate = self
    }

    private func setupRightBarButtonEnabled() {
        guard let isEnabled = productPresenter?.isRightBarButtonEnabled else {
            return
        }

        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }

    private func setupToolbar() {
        guard let viewModel = productPresenter?.productToolbarButtonViewModel else {
            toolbar.isHidden = true
            return
        }

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(title: viewModel.title,
                                           style: .plain,
                                           target: self,
                                           action: #selector(toolbarButtonAction))
        deleteButton.tintColor = viewModel.color
        toolbar.items = [flexible, deleteButton, flexible]
    }
}

// MARK: - ProductViewControllerProtocol

extension ProductViewController: ProductViewControllerProtocol {

    override func setupUI() {
        super.setupUI()

        title = productPresenter?.viewTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(leftBarButtonAction))
        if let systemItem = productPresenter?.rightBarButtonSystemItem {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem,
                                                                target: self,
                                                                action: #selector(rightBarButtonAction))
            setupRightBarButtonEnabled()
        }
        setupTableView()
        setupToolbar()
    }

    func reloadRow(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: .zero)], with: .automatic)
    }

    func insertRow(at index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: .zero)], with: .automatic)
    }

    func deleteRow(at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: .zero)], with: .automatic)
    }
}

// MARK: - UITableViewDataSource

extension ProductViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productPresenter?.numberOfProductCellTypes ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(at: indexPath.row), for: indexPath)
        setup(cell, at: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let productCellType = productPresenter?.productCellType(at: indexPath.row),
              let productCell = tableView.cellForRow(at: indexPath) else {
            return
        }

        switch productCellType {
        case .name:
            productCell.becomeFirstResponder()
        case .expirationDate:
            productPresenter?.didTapExpirationDateCell()
        case .datePicker:
            break
        }
    }
}

// MARK: - ProductNameTableViewCellDelegate

extension ProductViewController: ProductNameTableViewCellDelegate {

    func productNameTableViewCell(_ cell: ProductNameTableViewCell, didChangeName name: String) {
        productPresenter?.didChangeName(name)
        setupRightBarButtonEnabled()
    }
}

// MARK: - ProductDatePickerTableViewCellDelegate

extension ProductViewController: ProductDatePickerTableViewCellDelegate {

    func productDatePickerTableViewCell(_ cell: ProductDatePickerTableViewCell, didChangeDate date: Date) {
        productPresenter?.didChangeExpirationDate(date)
    }
}
