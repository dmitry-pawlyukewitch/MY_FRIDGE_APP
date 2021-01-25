import UIKit

class ProductTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProductTableViewCell"

    func setup(with viewModel: ProductViewModel) {
        textLabel?.text = viewModel.name
        detailTextLabel?.text = viewModel.date
    }
}
