import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    
}

extension ViewController: UITableViewDelegate {
    
}
