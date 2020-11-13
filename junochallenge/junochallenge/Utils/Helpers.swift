//
//  Helpers.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import Foundation
import UIKit

// MARK: - UIImageView Extension

extension UIImageView {

    // Define circle imageview
    func makeRounded() {
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.borderColor = colorPrimary.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
}

// MARK: - Unit Test

extension UIViewController {
    
    // Define a preload uiviewcontroller for tests
    func preload() {
        _ = self.view
    }
    
}
