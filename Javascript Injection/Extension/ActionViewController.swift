//
//  ActionViewController.swift
//  Extension
//
//  Created by Vo Huy on 6/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    var pageTitle = ""
    var pageURL = ""
    @IBOutlet var script: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let defaults = UserDefaults.standard
        if let savedURL = defaults.object(forKey: "pageURL") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                let url = try jsonDecoder.decode(URL.self, from: savedURL)
                pageURL = try! String(contentsOf: url)
                print(pageURL)
                
            } catch {
                print("Failed to load url")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [unowned self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    self.pageTitle = javaScriptValues["title"] as! String
                    self.pageURL = javaScriptValues["URL"] as! String
                    self.save()
                    
                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                }
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext!.completeRequest(returningItems: [item])
    }

}

extension ActionViewController {
    @objc func adjustForKeyBoard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    func save() {
        let url = URL(string: pageURL)
        let jsonEncoder = JSONEncoder()
        if let savedSata = try? jsonEncoder.encode(url) {
            let defaults = UserDefaults.standard
            defaults.set(savedSata, forKey: "pageURL")
        } else {
            print("Failed to save url")
        }
    }
}
