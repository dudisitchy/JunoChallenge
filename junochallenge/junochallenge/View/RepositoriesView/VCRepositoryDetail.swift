//
//  VCRepositoryDetail.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import UIKit
import AttributedTextView

class VCRepositoryDetail: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionText: AttributedTextView!
    
    // Variables filled by VCRepositories
    var repository: Item?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config Navigation Bar custom
        navigationItem.title = repository?.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        // Set user info
        imgUser.makeRounded()
        imgUser.image = image
        userLabel.text = repository?.owner?.login
        userLabel.textColor = colorSecundary
        
        // Build the user info string for TextView
        let descriptionTitle = NSLocalizedString("description", comment: "")
        let descriptionValue = " \(repository?.description ?? "")\n\n"
        let licenseTitle = NSLocalizedString("license", comment: "")
        let licenseValue = " \(repository?.license?.name ?? "")\n\n"
        let urlTitle = "URL:"
        let urlValue = " \(repository?.htmlUrl ?? "")\n\n"
        let createdTitle = NSLocalizedString("created", comment: "")
        let createdValue = " \(repository?.createdAt ?? "")\n\n"
        let updatedTitle = NSLocalizedString("updated", comment: "")
        let updatedValue = " \(repository?.updatedAt ?? "")\n\n"
        let languageTitle = NSLocalizedString("language", comment: "")
        let languageValue = " \(repository?.language ?? "")\n\n"
        let issuesTitle = NSLocalizedString("issues", comment: "")
        let issuesValue = " \(repository?.openIssues ?? 0)\n\n"
        let watchersTitle = NSLocalizedString("watchers", comment: "")
        let watchersValue = " \(repository?.watchers ?? 0)\n\n"
        
        // Configure margins for TextView
        descriptionText.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 0);
        
        // Configure text appearance for TextView
        descriptionText.attributer = descriptionTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + descriptionValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + licenseTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + licenseValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + urlTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + urlValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + createdTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + createdValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + updatedTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + updatedValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + languageTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + languageValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + issuesTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + issuesValue.color(UIColor.black).fontName("Lato-Medium").size(17)
            + watchersTitle.color(colorPrimary).fontName("Lato-Black").size(17)
            + watchersValue.color(UIColor.black).fontName("Lato-Medium").size(17)
    }
    
    // Back to VCRepositories
    @objc func back(sender: UIButton!) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
