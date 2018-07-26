//
//  ViewController.swift
//  Multibrowser
//
//  Created by Vo Huy on 7/25/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    weak var activeWebView: UIWebView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressBar.delegate = self
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Layout
extension ViewController {
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
}

// MARK: - User interaction
extension ViewController {
    @objc func addWebView() {
        createWebView(withURLString: "https://www.google.com")
    }
    
    func selectWebView(_ webView: UIWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
        addressBar.text = webView.request?.url?.absoluteString ?? ""
        webView.layer.borderWidth = 3
    }
    
    @objc func deleteWebView() {
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.index(of: webView) {
                stackView.removeArrangedSubview(webView)
                // remove the web view from the view hierarchy
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                } else {
                    var currentActiveIndex = Int(index)
                    
                    // if the deleted view was the last in the stack, go back one
                    if currentActiveIndex == stackView.arrangedSubviews.count {
                        currentActiveIndex -= 1
                    }
                    
                    if let newSelectedWebView = stackView.arrangedSubviews[currentActiveIndex] as? UIWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
}

// MARK: - WebViewDelegate, TextFieldDelegate, GestureRecognizerDelegate
extension ViewController: UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
        addressBar.text = webView.request?.url?.absoluteString ?? ""
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var address = addressBar.text else {
            textField.resignFirstResponder()
            return true
        }
        
        if !address.hasPrefix("https://") {
            address = "https://\(address)"
        }
        
        guard let url = URL(string: address) else {
            textField.resignFirstResponder()
            return true
        }
        
        if let webView = activeWebView {
            webView.loadRequest(URLRequest(url: url))
        } else {
            createWebView(withURLString: url.absoluteString)
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func createWebView(withURLString urlString: String) {
        let webView = UIWebView()
        webView.delegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: urlString)!
        webView.loadRequest(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
}
