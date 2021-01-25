import UIKit

private enum MyFridgeSectionType {
    case readyForEat
    case expired
}

class MyFridgePresenter: BasePresenter {

    private var myFridgeView: MyFridgeViewControllerProtocol? {
        view as? MyFridgeViewControllerProtocol
    }

    private var products: [Product] = []
    private var sectionTypes: [MyFridgeSectionType] {
        var sections: [MyFridgeSectionType] = []
        if !readyForEatProducts.isEmpty {
            sections.append(.readyForEat)
        }
        if !expiredProducts.isEmpty {
            sections.append(.expired)
        }
        return sections
    }
    private var readyForEatProducts: [Product] {
        products.filter({ !$0.isExpired })
    }
    private var expiredProducts: [Product] {
        products.filter({ $0.isExpired })
    }

    init(view: MyFridgeViewControllerProtocol) {
        super.init(view: view)
    }

    // MARK: - Private

    private func product(at index: Int, in section: Int) -> Product {
        let product: Product
        switch sectionTypes[section] {
        case .readyForEat:
            product = readyForEatProducts[index]
        case .expired:
            product = expiredProducts[index]
        }
        return product
    }

    private func isEmptyProducts(in sectionType: MyFridgeSectionType) -> Bool {
        switch sectionType {
        case .readyForEat:
            return readyForEatProducts.isEmpty
        case .expired:
            return expiredProducts.isEmpty
        }
    }

    private func fetchProducts() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let cdProducts = try? context?.fetch(CDProduct.fetchRequest()) as? [CDProduct]
        for cdProduct in cdProducts ?? [] {
            products.append(Product(name: cdProduct.name!, expirationDate: cdProduct.expirationDate!))
        }
        myFridgeView?.reloadData()
    }
}

// MARK: - MyFridgePresenterProtocol

extension MyFridgePresenter: MyFridgePresenterProtocol {

    var numberOfSections: Int {
        sectionTypes.count
    }

    func numberOfProducts(in section: Int) -> Int {
        switch sectionTypes[section] {
        case .readyForEat:
            return readyForEatProducts.count
        case .expired:
            return expiredProducts.count
        }
    }

    func productViewModel(at index: Int, in section: Int) -> ProductViewModel {
        let productDate = product(at: index, in: section).expirationDate
        return ProductViewModel(name: product(at: index, in: section).name,
                                date: DateFormatter.productDateFormatter.string(from: productDate))
    }

    func titleForHeader(in section: Int) -> String {
        switch sectionTypes[section] {
        case .readyForEat:
            return "MyFridge.TableViewHeader.ReadyForEat".localized
        case .expired:
            return "MyFridge.TableViewHeader.Expired".localized
        }
    }

    func titleForFooter(in section: Int) -> String {
        switch sectionTypes[section] {
        case .readyForEat:
            return "MyFridge.TableViewFooter.ReadyForEat".localized
        case .expired:
            return "MyFridge.TableViewFooter.Expired".localized
        }
    }

    func swipeTitle(in section: Int) -> String {
        switch sectionTypes[section] {
        case .readyForEat:
            return "MyFridge.SwipeAction.Eat".localized
        case .expired:
            return "MyFridge.SwipeAction.Delete".localized
        }
    }

    func swipeBackgroundColor(in section: Int) -> UIColor {
        switch sectionTypes[section] {
        case .readyForEat:
            return .link
        case .expired:
            return .red
        }
    }

    func didSelectProduct(at index: Int, in section: Int) {
        AppRouter.shared.showInfoProduct(product: product(at: index, in: section)) { [weak self] in
            self?.didSwipeProduct(at: index, in: section)
        }
    }

    func didSwipeProduct(at index: Int, in section: Int) {
        let sectionType = sectionTypes[section]
        let deletedProduct = product(at: index, in: section)
        products.removeAll(where: { $0 == deletedProduct })
        isEmptyProducts(in: sectionType) ?
            myFridgeView?.deleteSection(at: section) :
            myFridgeView?.deleteRow(at: index, in: section)
    }

    func addAction() {
        AppRouter.shared.showAddProduct(saveCompletion: { [weak self] product in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let cdProduct = CDProduct(context: context)
                cdProduct.name = product.name
                cdProduct.expirationDate = product.expirationDate
                context.insert(cdProduct)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            self?.products.append(product)
            self?.myFridgeView?.reloadData()
        })
    }

    // MARK: - BasePresenterProtocol

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchProducts()
    }
}
