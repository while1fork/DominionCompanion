//
//  SetFiltersViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetFiltersViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItem(_:)))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItem(_:))),
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(newItem(_:)))
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func newItem(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "NewFilter", sender: self)
    }
    
    @objc func savedSets(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "NewFilter", sender: self)
    }
    
    // MARK: UITableViewController Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterEngine.shared.filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetFilterCell") as? SetFilterCell else { return UITableViewCell()}
        cell.setData(filter: FilterEngine.shared.filters[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            FilterEngine.shared.removeFilter(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "EditFilter",
            let filterViewController = segue.destination as? NewFilterViewController
        {
            filterViewController.existingFilterIndex = indexPath.row
        }
    }
}
