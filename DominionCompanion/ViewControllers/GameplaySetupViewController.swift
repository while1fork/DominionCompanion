//
//  GameplaySetupViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class GameplaySetupViewController: UITableViewController {    
    var displayingSavedSet = false
    
    var setModel: SetModel?
    
    var tableData: [GameplaySection] = []
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        
        guard let model = setModel else { return }
        tableData = model.getSections(tableView: tableView)
        
        if displayingSavedSet {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(pinSet))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSet))
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { tableData[section].title }
    
    override func numberOfSections(in tableView: UITableView) -> Int { tableData.count }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tableData[section].rows.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableData[indexPath.section].rows[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AttributedCardCell else { return }
        performSegue(withIdentifier: "ViewCard", sender: cell.card)
    }
    
    @objc func saveSet() {
        let alert = AlertBuilder.withTextField(title: "Save Set") {value in
            guard let model = self.setModel else { return }
            SavedSets.shared.saveSet(name: value, model: model)
        }
        present(alert, animated: true)
    }
    
    @objc func pinSet() {
        let alert = AlertBuilder.confirmation(title: "Import to Set Builder", confirmText: "Import", message: "Import this set to the set builder to start with these cards as a base for a new set?") {
            guard let model = self.setModel else { return }
            SetBuilder.shared.pinnedCards = model.cards
            SetBuilder.shared.pinnedEvents = model.events
            SetBuilder.shared.pinnedLandmarks = model.landmarks
            SetBuilder.shared.pinnedProjects = model.projects
            SetBuilder.shared.pinnedWays = model.ways
            guard let root = self.navigationController?.tabBarController else { return }
            root.selectedIndex = 0
        }
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CardViewController, let card = sender as? Card else { return }
        vc.card = card
    }
}

