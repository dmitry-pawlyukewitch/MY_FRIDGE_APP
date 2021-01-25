import UIKit

protocol MyFridgePresenterProtocol: BasePresenterProtocol {

    var numberOfSections: Int { get }
    func numberOfProducts(in section: Int) -> Int
    func productViewModel(at index: Int, in section: Int) -> ProductViewModel
    func titleForHeader(in section: Int) -> String
    func titleForFooter(in section: Int) -> String
    func swipeTitle(in section: Int) -> String
    func swipeBackgroundColor(in section: Int) -> UIColor
    func didSelectProduct(at index: Int, in section: Int)
    func didSwipeProduct(at index: Int, in section: Int)
    func addAction()
}
