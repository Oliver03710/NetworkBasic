//
//  FetchImageCollectionViewCell.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

class FetchImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var searchImageVIew: UIImageView!
    
    func configureFetchImageCells() {
        
        searchImageVIew.clipsToBounds = true
        searchImageVIew.layer.cornerRadius = 12
        searchImageVIew.contentMode = .scaleAspectFill
        
    }
    
}
