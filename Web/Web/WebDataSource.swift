//
//  Petition.swift
//  Web
//
//  Created by Vo Huy on 6/15/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class WebDataSource: NSObject {
    var petitions = [[String: String]]()
}

extension WebDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["subtitle"]
        return cell
    }
}
