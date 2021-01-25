import UIKit

class BaseViewController: UIViewController {

    var presenter: BasePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }
}

// MARK: - BaseViewControllerProtocol

extension BaseViewController: BaseViewControllerProtocol {

    @objc
    func setupUI() {
    }
}
