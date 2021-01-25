import UIKit

class AppRouter {

    private var navigationController: UINavigationController?
    private var presentedNavigationController: UINavigationController?

    static var shared: AppRouter = {
        let instance = AppRouter()
        return instance
    }()

    private init() {
    }

    func setup(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func setupInitialModule() {
        let myFridgeModule = createMyFridgeModule()
        navigationController?.setViewControllers([myFridgeModule], animated: false)
    }

    func dismissPresentedNavigationController(animated: Bool, completion: (() -> Void)? = nil) {
        presentedNavigationController?.dismiss(animated: animated) { [weak self] in
            self?.presentedNavigationController = nil
            completion?()
        }
    }

    func showInfoProduct(product: Product, toolbarButtonComplition: @escaping () -> Void) {
        let infoProductModule = createInfoProductModule(product: product,
                                                        toolbarButtonComplition: toolbarButtonComplition)
        let productNavigationController = UINavigationController(rootViewController: infoProductModule)
        navigationController?.present(productNavigationController, animated: true) { [weak self] in
            self?.presentedNavigationController = productNavigationController
        }
    }

    func showAddProduct(saveCompletion: @escaping (Product) -> Void) {
        let addProductModule = createAddProductModule(saveCompletion: saveCompletion)
        let productNavigationController = UINavigationController(rootViewController: addProductModule)
        navigationController?.present(productNavigationController, animated: true) { [weak self] in
            self?.presentedNavigationController = productNavigationController
        }
    }

    func showDiscardProductChangesAlert(discardCompliton: @escaping () -> Void) {
        let alertController = UIAlertController(title: "",
                                                message: "Product.DiscardChangesAlert.Message".localized,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Product.DiscardChangesAlert.Discard".localized,
                                                style: .default,
                                                handler: { _ in
                                                    discardCompliton()
                                                }))
        alertController.addAction(UIAlertAction(title: "General.Cancel".localized, style: .cancel))
        presentedNavigationController?.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Private

    private func createMyFridgeModule() -> UIViewController {
        let viewController = MyFridgeViewController()
        let presenter = MyFridgePresenter(view: viewController)
        viewController.presenter = presenter
        return viewController
    }

    private func createInfoProductModule(product: Product,
                                         toolbarButtonComplition: @escaping () -> Void) -> UIViewController {
        let viewController = ProductViewController()
        let presenter = InfoProductPresenter(view: viewController,
                                             product: product,
                                             toolbarButtonComplition: toolbarButtonComplition)
        viewController.presenter = presenter
        return viewController
    }

    private func createAddProductModule(saveCompletion: @escaping (Product) -> Void) -> UIViewController {
        let viewController = ProductViewController()
        let presenter = AddProductPresenter(view: viewController, saveCompletion: saveCompletion)
        viewController.presenter = presenter
        return viewController
    }
}
