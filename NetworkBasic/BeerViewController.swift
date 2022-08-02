//
//  BeerViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/01.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class BeerViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getDataFromServer()
    }

    
    // MARK: - Networking
    
    func getDataFromServer() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                self.nameLabel.text = beerName
                print(beerName)
                
                guard let image = json[0]["image_url"].url else { return }
                print(image)
                self.beerImageView.kf.setImage(with: image)
                
                
                let description = json[0]["description"].stringValue
                print(description)
                self.descriptionTextView.text = description
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        nameLabel.setLabels()
    }
    
    
    
    
    

}
