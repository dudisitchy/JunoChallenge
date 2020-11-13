//
//  VCRepositories.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import SDWebImage

class VCRepositories: UIViewController {

    var repositoriesViewModel = GitRepositoriesViewModel()
    var termSearch: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingActivity: NVActivityIndicatorView!
    @IBOutlet weak var searchingBar: UISearchBar!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config Navigation Bar custom
        navigationController?.navigationBar.barTintColor = colorPrimary
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 19)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        // Listen to API error connection
        NotificationCenter.default.addObserver(self, selector: #selector(handleError(notification:)), name: Notification.Name("callAPIError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrorHasContent(notification:)), name: Notification.Name("callAPIErrorHasContent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNoEntries(notification:)), name: Notification.Name("callAPINoEntries"), object: nil)
        
        // Initial screen configuration
        tableView.isHidden = true
        loadingActivity.stopAnimating()
        infoLabel.text = NSLocalizedString("initial_info", comment: "")
        infoLabel.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Dynamic row height config
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Handle view for screen error
    func initialMethod(msg: String) {
        // UI changes in main tread
        DispatchQueue.main.async {
            if msg != "has_content" {
                self.tableView.isHidden = true
                self.loadingActivity.stopAnimating()
                self.infoLabel.text = NSLocalizedString(msg, comment: "")
                self.infoLabel.isHidden = false
            }
            
            if msg != "no_entries" {
                self.view.makeToast(NSLocalizedString("error_toast_message", comment: ""), duration: 3.0, position: .bottom)
            }
        }
    }
    
    // Fill page
    func pageSetup(term: String)  {
        // API call from viewmodel class
        self.repositoriesViewModel.fetchRepositories(search: term)
        self.closureSetUp()
    }
    
    // Handle errors from API calls
    @objc func handleError(notification: NSNotification) {
        initialMethod(msg: "initial_info")
    }
    
    @objc func handleNoEntries(notification: NSNotification) {
        initialMethod(msg: "no_entries")
    }
    
    @objc func handleErrorHasContent(notification: NSNotification) {
        initialMethod(msg: "has_content")
    }
    
    // Update tableview when data was set in viewmodel
    func closureSetUp()  {
        repositoriesViewModel.reloadList = { [weak self] () in
            // UI changes in main tread
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            // Prepare data and send to VCRepositoryDetail
            if let destinationViewController = segue.destination as? VCRepositoryDetail {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let index = indexPath.row
                
                guard let cell = sender as? RepositoriesTableViewCell else {
                    return
                }
                
                guard let userImage = cell.urlToImage.image else {
                    return
                }
                
                // Hide keyboard if it is open
                searchingBar.endEditing(true)
                
                // Fill data for VCRepositoryDetail
                destinationViewController.repository = repositoriesViewModel.gitRepositories[index]
                destinationViewController.image = userImage
            }
        }
    }
    
}
