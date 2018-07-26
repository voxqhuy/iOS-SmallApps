//
//  ViewController.swift
//  SwiftSearcher
//
//  Created by Vo Huy on 7/26/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UITableViewController {

    let dataSource = ProjectDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favorites") as? [Int] {
            dataSource.favorites = savedFavorites
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if dataSource.favorites.contains(indexPath.row) {
            return .delete
        } else {
            return .insert
        }
    }
}

// MARK: - Layout
extension ViewController {
    func showTutorial(_ which: Int) {
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
