import Foundation

class BasePresenter {

    weak var view: BaseViewControllerProtocol?

    init(view: BaseViewControllerProtocol) {
        self.view = view
    }
}

// MARK: - BasePresenterProtocol

extension BasePresenter: BasePresenterProtocol {

    @objc
    func viewDidLoad() {
        view?.setupUI()
    }
}
