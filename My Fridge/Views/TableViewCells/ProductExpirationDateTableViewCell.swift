import UIKit

class ProductExpirationDateTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProductTableViewCell"

    @IBOutlet private weak var productExpirationDateTitleLabel: UILabel!
    @IBOutlet private weak var productExpirationDateValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    func setup(with viewModel: ProductExpirationDateViewModel) {
        productExpirationDateValueLabel.text = DateFormatter.productDateFormatter.string(from: viewModel.date)
        productExpirationDateValueLabel.textColor = viewModel.valueTextColor
    }

    // MARK: - Private

    private func setupUI() {
        productExpirationDateTitleLabel.text = "ProductExpirationDateTableViewCell.Title".localized
    }
}
