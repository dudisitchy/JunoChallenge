//
//  GitRepositoriesViewModel.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import Foundation

class GitRepositoriesViewModel {
    
    var reloadList = {() -> () in }
    var searchTerm: String?
    
    var gitRepositories : [Item] = [] {
        // Reload list when data set
        didSet {
            reloadList()
        }
    }
    
}

extension GitRepositoriesViewModel {
    
    // Call the search service and fill the Item object
    func fetchRepositories(search: String) {
        // Verify if is a new search "term"
        if searchTerm != search {
            searchTerm = search
            self.gitRepositories.removeAll()
        }
        
        // Call service and handle the result for the view
        ServiceManager.shared.get(for: "\(apiBaseUrl)\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)", result: { jsonData in
            if jsonData != nil {
                let decoder = JSONDecoder()
                
                do {
                    // Parse the Json result into Repositories
                    let repositories = try decoder.decode(Repositories.self, from: jsonData!)
                    
                    // Return no results
                    if repositories.total_count == 0 || repositories.message?.count ?? 0 > 0 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callAPINoEntries"), object: nil)
                    }
                    else {
                        // Fill Repository Items objects
                        for item in repositories.items! {
                            self.gitRepositories.append(item)
                            totalItems += 1
                        }
                    }
                } catch {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callAPINoEntries"), object: nil)
                }
            }
            else {
                // Error calling API
                if page > 1 {
                    // There is data with same "term" on screen
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callAPIErrorHasContent"), object: nil)
                }
                else {
                    // New search "term" error
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callAPIError"), object: nil)
                }
            }
        })
    }
    
}
