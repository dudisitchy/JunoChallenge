//
//  junochallengeTests.swift
//  junochallengeTests
//
//  Created by Eduardo Maia on 12/11/20.
//

import XCTest
import UIKit
@testable import JunoChallenge

class junochallengeTests: XCTestCase {

    var navigationController: UINavigationController!
    var repositoriesVC: VCRepositoryDetail!
    
    override func setUpWithError() throws {
        navigationController = UINavigationController()
        repositoriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCRepositoryDetail") as? VCRepositoryDetail

        navigationController.setViewControllers([repositoriesVC], animated: false)

        repositoriesVC.preload()
    }

    override func tearDownWithError() throws {
        navigationController = nil
        repositoriesVC = nil
    }

    func testPerformanceExample() throws {
        let term: String = "ios"
        var items: [Item] = []
        
        self.measure {
            ServiceManager.shared.get(for: "\(apiBaseUrl)\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)") { result in
                let repositories = try! JSONDecoder().decode(Repositories.self, from: result!)
                
                for item in repositories.items! {
                    items.append(item)
                }
            }
        }
    }
    
    // Test API normal results
    func testSearchTerms() throws {
        let term: String = "ios"
        
        ServiceManager.shared.get(for: "\(apiBaseUrl)\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)") { result in
            XCTAssertNotNil(try! JSONDecoder().decode(Repositories.self, from: result!))
        }
    }
    
    // Test API call when no "term" is wrote
    func testSearchNoTerms() throws {
        let term: String = ""
        
        ServiceManager.shared.get(for: "\(apiBaseUrl)\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)") { result in
            let rep = try! JSONDecoder().decode(Repositories.self, from: result!)
            XCTAssertEqual(rep.total_count, 0)
            XCTAssertNil(rep.items)
        }
    }
    
    // Test API call when result is no entries
    func testSearchTermsNotFound() throws {
        let term: String = "wjerhwk"
        
        ServiceManager.shared.get(for: "\(apiBaseUrl)\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)") { result in
            let rep = try! JSONDecoder().decode(Repositories.self, from: result!)
            XCTAssertEqual(rep.total_count, 0)
            XCTAssertNil(rep.message)
        }
    }
    
    // Test image load from URL
    func testImageLoadFromURL() throws {
        let didFinish = self.expectation(description: #function)
        
        let term: String = "ios"
        
        ServiceManager.shared.get(for: "\(apiBaseUrl)\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\(apiPage)\(page)\(apiPerPage)\(apiLimitPage)") { result in
            let rep = try! JSONDecoder().decode(Repositories.self, from: result!)
    
            XCTAssertNotNil(rep.items![0].owner?.avatarUrl)
            
            self.repositoriesVC.imgUser.sd_setImage(with: URL(string: (rep.items![0].owner?.avatarUrl)!), placeholderImage: nil, options: [], progress: nil, completed: {(image, error, cacheType, url) in
                self.repositoriesVC.imgUser.image = image
                
                if self.repositoriesVC.imgUser.image != nil {
                    didFinish.fulfill()
                } else {
                    XCTFail()
                }
            })
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    // Test load image when resource is emprty
    func testNoImageLoadFromURL() throws {
        self.repositoriesVC.imgUser.sd_setImage(with: URL(string: ""), placeholderImage: defaultImage, options: [], progress: nil, completed: {(image, error, cacheType, url) in
            if (error != nil) {
                self.repositoriesVC.imgUser.image = defaultImage
            }
            
            XCTAssertNotNil(self.repositoriesVC.imgUser.image)
        })
    }

}
