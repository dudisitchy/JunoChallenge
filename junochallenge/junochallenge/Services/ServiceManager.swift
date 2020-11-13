//
//  ServiceManager.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import Foundation

class ServiceManager {
    
    static let shared: ServiceManager = ServiceManager()
    
    // Cache configuration
    private let allowedDiskSize = 100 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "apiCache")
    }()

    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        
        return URLSession(configuration: sessionConfiguration)
    }

    // Call API and mange if use cached data or url data
    func get(for url: String, result: @escaping (_ json: Data?) -> ()) {
        guard let downloadUrl = URL(string: url) else { return }
        
        let urlRequest = URLRequest(url: downloadUrl)
        
        createAndRetrieveURLSession().dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                // try to fetching cached data if exist
                if let cachedData = self.cache.cachedResponse(for: urlRequest) {
                    result(cachedData.data)
                }
                else {
                    result(nil)
                }
            }
            else {
                // Download content then cache the data
                let cachedData = CachedURLResponse(response: response!, data: data!)
                self.cache.storeCachedResponse(cachedData, for: urlRequest)
                result(data)
            }
        }.resume()
    }
    
}
