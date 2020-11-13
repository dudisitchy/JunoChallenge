//
//  RepositoriesTableViewCell.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import UIKit
import NVActivityIndicatorView

class RepositoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var urlToImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = colorPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
