//
//  ListTableViewCell.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var totalAudienceLabel: UILabel!
    
    
    // MARK: - Helper Functions
    
    func setUI() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemTeal
        
        rankingLabel.font = .boldSystemFont(ofSize: 20)
        rankingLabel.textAlignment = .center
        rankingLabel.textColor = .systemTeal
        
        releaseDateLabel.font = .systemFont(ofSize: 16)
        releaseDateLabel.textAlignment = .center
        
        totalAudienceLabel.font = .systemFont(ofSize: 16)
        totalAudienceLabel.textAlignment = .center
    }
}
