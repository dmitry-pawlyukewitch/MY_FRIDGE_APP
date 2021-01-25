import UIKit

protocol ProductDatePickerTableViewCellDelegate: class {

    func productDatePickerTableViewCell(_ cell: ProductDatePickerTableViewCell, didChangeDate date: Date)
}

class ProductDatePickerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProductDatePickerTableViewCell"

    @IBOutlet private weak var datePicker: UIDatePicker!

    weak var delegate: ProductDatePickerTableViewCellDelegate?

    func setup(with viewModel: ProductDatePickerViewModel) {
        datePicker.date = viewModel.date
    }

    // MARK: - Actions

    @IBAction func didChangedDate(_ sender: Any) {
        delegate?.productDatePickerTableViewCell(self, didChangeDate: datePicker.date)
    }
}
