//
//  ExtensionsRepositories.swift
//  junochallenge
//
//  Created by Eduardo Maia on 13/11/20.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SDWebImage

// MARK: - TableView Extension
extension VCRepositories : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Handle screen to show infos
        if repositoriesViewModel.gitRepositories.count > 0 {
            infoLabel.isHidden = true
            tableView.isHidden = false
            loadingActivity.stopAnimating()
        }
        
        return repositoriesViewModel.gitRepositories.count
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pagination: load news items when it requires
        checkForLastCell(with: indexPath)
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoriesTableViewCell
        
        // Start loading indicator
        tableViewCell.activityIndicator.startAnimating()
        
        // Set circle Imageview
        tableViewCell.urlToImage.makeRounded()
        
        tableViewCell.tintColor = colorPrimary
        
        // Fill row info
        let data = repositoriesViewModel.gitRepositories[indexPath.row]

        tableViewCell.titleLabel?.text = data.name
        tableViewCell.languageLabel?.text = "\(NSLocalizedString("language", comment: "")) \(data.language ?? "")"
        tableViewCell.ownerLabel?.text = "\(NSLocalizedString("user", comment: "")) \(data.owner?.login ?? "")"
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = repositoriesViewModel.gitRepositories[indexPath.row]

        // Download user image
        (cell as? RepositoriesTableViewCell)?.urlToImage.sd_setImage(with: URL(string: data.owner?.avatarUrl ?? ""), placeholderImage: defaultImage, options: [], progress: nil, completed: {(image, error, cacheType, url) in
            (cell as? RepositoriesTableViewCell)?.activityIndicator.stopAnimating()
        })

        // Insert loading spin at the end of tableview
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1

        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = NVActivityIndicatorView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(60)), type: .circleStrokeSpin, color: colorPrimary, padding: 15)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    // Checking Cell
    private func checkForLastCell(with indexPath:IndexPath) {
        if indexPath.row == (repositoriesViewModel.gitRepositories.count - 1) {
            if totalItems + 1 > repositoriesViewModel.gitRepositories.count {
                page += 1
                pageSetup(term: termSearch ?? "")
            }
        }
    }
    
}

// MARK: - SearchBar Extension
extension VCRepositories : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        infoLabel.isHidden = true
        
        // Verify if it's a new "term" search an configure screen
        if searchBar.text != termSearch {
            termSearch = searchBar.text
            page = 1
            totalItems = 0
            loadingActivity.startAnimating()
            tableView.tableFooterView?.isHidden = true
            tableView.isHidden = true
        }
        
        // New API call
        pageSetup(term: searchBar.text!)
        
        // Hide keyboard if it is open
        searchBar.endEditing(true)
    }
    
}
