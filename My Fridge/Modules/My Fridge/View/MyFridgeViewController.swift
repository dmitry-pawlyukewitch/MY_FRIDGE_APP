import UIKit

class MyFridgeViewController: BaseViewController {

    private var myFridgePresenter: MyFridgePresenterProtocol? {
        presenter as? MyFridgePresenterProtocol
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var emptyMessageLabel: UILabel!

    // MARK: - Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ProductTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
    }

    private func swipeAction(at indexPath: IndexPath) -> UIContextualAction {
        let swipeAction = UIContextualAction(style: .destructive,
                                             title: myFridgePresenter?.swipeTitle(in: indexPath.section),
                                             handler: { [weak self] _, _, _ in
            self?.myFridgePresenter?.didSwipeProduct(at: indexPath.row, in: indexPath.section)
        })
        swipeAction.backgroundColor = myFridgePresenter?.swipeBackgroundColor(in: indexPath.section)
        return swipeAction
    }

    // MARK: - Action

    @objc
    private func rightBarButtonAction() {
        myFridgePresenter?.addAction()
    }
}

// MARK: - MyFridgeViewControllerProtocol

extension MyFridgeViewController: MyFridgeViewControllerProtocol {

    override func setupUI() {
        super.setupUI()

        title = "MyFridge.ViewTitle".localized
        setupTableView()
        emptyMessageLabel.text = "MyFridge.EmptyMessage".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(rightBarButtonAction))
    }

    func deleteRow(at index: Int, in section: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: section)], with: .automatic)
    }

    func deleteSection(at index: Int) {
        tableView.deleteSections([index], with: .automatic)
    }

    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension MyFridgeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = myFridgePresenter?.numberOfSections ?? .zero
        emptyView.isHidden = numberOfSections != .zero
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myFridgePresenter?.numberOfProducts(in: section) ?? .zero
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        myFridgePresenter?.titleForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        myFridgePresenter?.titleForFooter(in: section)
    }

    func tableView(_ : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath)
        if let productCell = cell as? ProductTableViewCell,
           let productViewModel = myFridgePresenter?.productViewModel(at: indexPath.row, in: indexPath.section) {
            productCell.setup(with: productViewModel)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyFridgeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myFridgePresenter?.didSelectProduct(at: indexPath.row, in: indexPath.section)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction(at: indexPath)])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
