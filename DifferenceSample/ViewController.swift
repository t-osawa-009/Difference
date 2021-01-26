import UIKit
import Difference

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func reload(items: [String]) {
        tableView.performBatchUpdates {
            self.array = items
            
        } completion: { (_) in
            <#code#>
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var newArray = array
        newArray.insert("⭐️", at: 0)
        reload()
    }
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        var newArray = array
        array.removeLast()
        reload()
    }
    private let differenceWrapper = DifferenceWrapper<String>()
    private var array: [String] = []
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
}

extension ViewController: UITableViewDelegate {
    
}
