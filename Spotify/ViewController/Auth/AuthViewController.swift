//
//  AuthViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import UIKit
import WebKit
import LikeSwiftUI

class AuthViewController: UIViewController,WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        configureWebView()
    }
    
    private func configureWebView(){
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        webView.scrollView.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        webView.edgesToSuperview()
        guard let url = AuthManager.shared.signInURL else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        //Exchange the code for access token
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            if let error = component?.queryItems?.first(where: {$0.name == "error"})?.value {
                print("Failed to get code: \(error)")
                completionHandler?(false)
            }
            return
        }
        webView.isHidden = true
        
        Task {
            do {
                try await AuthManager.shared.exchangeCodeForToken(code: code)
                await MainActor.run {
                    navigationController?.popToRootViewController(animated: true)
                    completionHandler?(true)
                }
            } catch {
                print(error)
                completionHandler?(false)
            }
        }
        
        print("Code: \(code)")
    }
    
}
