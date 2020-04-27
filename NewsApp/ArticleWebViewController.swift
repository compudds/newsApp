//
//  ArticleWebViewController.swift
//  NewsFun
//
//  Created by zappycode on 4/27/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import WebKit
import MessageUI
import SafariServices

class ArticleWebViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var article = Article()
    
    var emailSent = 0
       
    var textSent = 0
    
     @IBAction func textButton(_ sender: Any) {
        
        sendText()
        
    }
    
    @IBAction func emailtButton(_ sender: Any) {
           
        sendEmail()
        
       }

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .video
        
        if let url = URL(string: article.url) {
            
            webView.load(URLRequest(url: url))
            
            let safariVC = SFSafariViewController(url: url)
            
            present(safariVC, animated: true, completion: nil)
            
            /*let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self*/
           
        }
        
        let addText = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendText))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let addEmail = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendEmail))
       
        toolbarItems = [addText, spacer, addEmail]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendText() {
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.subject = "Check out this article!"
        
        messageVC.body =  "Link: " + self.article.url
        
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
        
    }
    
    @objc func sendEmail() {
        
        let mc = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setSubject("Check out this article!")
        
        mc.setMessageBody("Link: " + self.article.url, isHTML: true)
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            textSent = 1
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
        
        textSentSuccess()
    }
    
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
            
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
            
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
            emailSent = 1
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
            
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        emailSentSuccess()
    }
    
    func emailSentSuccess() {
        
        if emailSent == 0 {
            
            let alert = UIAlertController(title: "Your email failed to send or was cancelled.", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Your email has been sent.", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            emailSent = 0
        }
        
        
    }
    
    func textSentSuccess() {
        
        if textSent == 0 {
            
            let alert = UIAlertController(title: "Your text failed to send or was cancelled.", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Your text has been sent.", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            textSent = 0
            
        }
        
        
    }
    

    
}
