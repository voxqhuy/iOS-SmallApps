//
//  ViewController.swift
//  Secret Swift
//
//  Created by Vo Huy on 7/19/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        #if targetEnvironment(simulator)
        var passwordDidExist = false
        let ac = UIAlertController(title: "Enter a password", message: "Your secret text needs a password, please enter one", preferredStyle: .alert)
        
        if KeychainWrapper.standard.string(forKey: "Password") != nil {
            passwordDidExist = true
            ac.title = "Enter the password"
            ac.message = nil
        }
        
        ac.addTextField {
            tf in
            tf.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self, ac] action in
            let password = ac.textFields![0]
            
            if passwordDidExist {
                self.loginUser(byPassword: password.text!)
            } else {
                self.createPassword(with: password.text!)
            }
        }
        
        ac.addAction(submitAction)
        ac.actions[0].isEnabled = false
        present(ac, animated: true)
        #else
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authenticataion failed", message: "you could not be verified; please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        #endif
        
    }
}

// MARK: - Additional helpers
extension ViewController {
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            secret.contentInset = UIEdgeInsets.zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    @objc func saveSecretMessage() {
        if !secret.isHidden {
            _ = KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
            secret.resignFirstResponder()
            secret.isHidden = true
            title = "Nothing to see here"
        }
    }
    
    func createPassword(with password: String) {
        _ = KeychainWrapper.standard.set(password.text!, forKey: "Password")
        let ac = UIAlertController(title: "Password created", message: "You created a new password", preferredStyle: .alert)
        ac.addAction((UIAlertAction(title: "OK", style: .default)))
        present(ac, animated: true)
    }
    
    func loginUser(byPassword password: String) {
        if password == "pass" {
            unlockSecretMessage()
        } else {
            let ac = UIAlertController(title: "Wrong password", message: "The password you entered doesn't match with our record", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp: UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[0].isEnabled = (tf.text != "")
    }
}

