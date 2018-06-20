//
//  ViewController.swift
//  NamesToSpaces
//
//  Created by Vo Huy on 6/19/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    
    var peopleData = PeopleData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                peopleData.people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
//            peopleData.people = NSKeyedUnarchiver.unarchiveObject(with: people) as! [Person]
        }
        collectionView?.dataSource = peopleData
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        // find a path in disk (documents) to write the image to
        let imageName = UUID().uuidString
        let imagePath = Utils.getDocumentsDirectory().appendingPathComponent(imageName)
        
        // convert image to data
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        peopleData.people.append(person)
        collectionView?.reloadData()
        save()
        
        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = peopleData.people[indexPath.row]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self, ac] _ in
            
            person.name = ac.textFields![0].text!
            self.collectionView?.reloadData()
            self.save()
        })
        
        present(ac, animated: true)
    }
}

// MARK: - User Iteraction
extension ViewController {
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Helper methods
extension ViewController {
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(peopleData.people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
//        let savedData = NSKeyedArchiver.archivedData(withRootObject: peopleData.people)
//        let defaults = UserDefaults.standard
//        defaults.set(savedData, forKey: "people")
    }
}
