//
//  WebViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    // App Transport Security Settings (ATS 설정)
    // 대부분의 http는 차단(보안상의 문제)
    var destinationURL: String = "https://www.apple.com"
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openWebPage(url: destinationURL)
        searchBar.delegate = self
    }
    

    // MARK: - Helper Functions
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func xmarkBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func backBarButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func forwardBarButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
}


// MARK: - Extension: UISearchBarDelegate

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        openWebPage(url: text)
    }
}
