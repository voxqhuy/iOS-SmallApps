//
//  ViewController.swift
//  Web
//
//  Created by Vo Huy on 6/15/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var urlString = String()
    var dataSource = WebDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        urlString = navigationController?.tabBarItem.tag == 0 ? PetitionAPI.recentURLString : PetitionAPI.topRatedURLString
        if let petitionData = PetitionAPI.fetchPetitions(forURL: urlString) {
            dataSource.petitions = petitionData
        } else {
            showError()
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailItem = dataSource.petitions[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "There was a problem loading the feed; please check your connection and try again",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

