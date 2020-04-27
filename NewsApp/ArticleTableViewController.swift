//
//  ArticleTableViewController.swift
//  
//
//  Created by zappycode on 4/27/18.
//

import UIKit
import Kingfisher
import SafariServices

class ArticleTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getArticles()
        
        tableView.separatorStyle = .none
        
        _ = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(getArticles), userInfo: nil, repeats: true)
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    @objc func getArticles() {
        
        NewsHelper().getArticles { (articles) in
             DispatchQueue.main.async {
                self.articles = articles
                self.tableView.reloadData()
            }
        }
     
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell {

            let article = articles[indexPath.row]
            
            cell.titleLabel.text = article.title
            cell.categoryLabel.text = article.category.rawValue
            cell.categoryLabel.backgroundColor = article.categoryColor
            
            let url = URL(string: article.urlToImage)
            
            cell.articleImageView.kf.setImage(with: url)
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = articles[indexPath.row]
        
        if let url = URL(string: article.url) {
            
            let safariVC = SFSafariViewController(url: url)
            
            safariVC.preferredBarTintColor = .darkGray
            
            safariVC.preferredControlTintColor = .white
            
            self.present(safariVC, animated: true, completion: nil)
            
            safariVC.delegate = self
            
        }
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToURL" {
            if let article = sender as? Article {
                if let webVC = segue.destination as? ArticleWebViewController {
                    webVC.article = article
                }
            }
        }
    }
    
    @IBAction func reloadTapped(_ sender: Any) {
        
        getArticles()
        
    }
    
}

class ArticleCell : UITableViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
   
}
