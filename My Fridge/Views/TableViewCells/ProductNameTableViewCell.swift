import UIKit

protocol ProductNameTableViewCellDelegate: class {

    func productNameTableViewCell(_ cell: ProductNameTableViewCell, didChangeName name: String)
}

class ProductNameTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProductNameTableViewCell"

    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productNameTextField: UITextField!

    weak var delegate: ProductNameTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func becomeFirstResponder() -> Bool {
        productNameTextField.becomeFirstResponder()
    }

    func setup(with viewModel: ProductNameViewModel) {
        productNameTextField.text = viewModel.name
        productNameTextField.isEnabled = viewModel.isEditingEnabled
    }

    // MARK: - Actions

    @IBAction private func productNameChanged(_ sender: Any) {
        delegate?.productNameTableViewCell(self, didChangeName: productNameTextField.text ?? "")
    }

    // MARK: - Private

    private func setupUI() {
        productNameTextField.delegate = self
        productNameLabel.text = "ProductNameTableViewCell.Title".localized
        productNameTextField.placeholder = "ProductNameTableViewCell.Placeholder".localized
        _ = becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension ProductNameTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
