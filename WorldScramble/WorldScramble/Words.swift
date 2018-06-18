//
//  Words.swift
//  WorldScramble
//
//  Created by Vo Huy on 6/15/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class Words: NSObject {
    var allWords = [String]()
    var usedWords = [String]()
}

extension Words: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}
