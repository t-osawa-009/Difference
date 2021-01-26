import UIKit
import Difference

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DifferenceWrapper Sample"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        differenceWrapper.notifity { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .initial(let array):
                self.array = array
                self.tableView.reloadData()
            case .update(let array, deletions: let deletions, insertions: let insertions, moves: let moves):
                self.tableView.performBatchUpdates {
                    self.array = array
                    self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .left)
                    self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                    moves.forEach { move in
                        let from = IndexPath(row: move.from, section: 0)
                        let to = IndexPath(row: move.to, section: 0)
                        self.tableView.moveRow(at: from, to: to)
                    }
                } completion: { (_) in
                    
                }
            }
        }
    }
    
    func reload(items: [String]) {
        differenceWrapper.diff(other: items)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var newArray = array
        newArray.insert(String.randomEmoji , at: 0)
        reload(items: newArray)
    }
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        guard !array.isEmpty else { return }
        var newArray = array
        newArray.removeLast()
        reload(items: newArray)
    }
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        guard !array.isEmpty else { return }
        let newArray = array.shuffled()
        reload(items: newArray)
    }
    
    private let differenceWrapper = DifferenceWrapper<[String]>()
    private var array: [String] = []
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = array[indexPath.row]
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
}

extension ViewController: UITableViewDelegate { }

extension String{
    static var randomEmoji: String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
    }
}
