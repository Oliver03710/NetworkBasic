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
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var totalBeers: [Beers] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: BeerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BeerCollectionViewCell.reuseIdentifier)
    }

    
    // MARK: - Networking
    
    func getDataFromServer() {
        
        let url = "https://api.punkapi.com/v2/beers"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                let beerName = json[0]["name"].stringValue
//                self.nameLabel.text = beerName
//                print(beerName)
//
//                guard let image = json[0]["image_url"].url else { return }
//                print(image)
//                self.beerImageView.kf.setImage(with: image)
//
//
//                let description = json[0]["description"].stringValue
//                print(description)
//                self.descriptionTextView.text = description
                
                for beer in json.arrayValue {
                    
                    let name = beer["name"].stringValue
                    guard let image = beer["image_url"].url else { return }
                    let description = beer["description"].stringValue
                    
                    let data = Beers(beersName: name, image: image, description: description)
                    
                    self.totalBeers.append(data)
                    
                }
                
                print(self.totalBeers)
                print(self.totalBeers[0].image)
                print(self.totalBeers[0].beersName)
                print(self.totalBeers[0].description)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalBeers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.reuseIdentifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.beerImageView.kf.setImage(with: totalBeers[indexPath.row].image)
        cell.beerImageView.contentMode = .scaleAspectFit
        
        cell.beerName.text = totalBeers[indexPath.row].beersName
        
        cell.beerDescription.text = totalBeers[indexPath.row].description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wsize = UIScreen.main.bounds.size.width
                switch(wsize){
                case 414:
                    return CGSize(width: 190, height: 102)
                case 375:
                    return CGSize(width: 190, height: 102)
                case 320:
                    return CGSize(width: 174, height: 102)
                default:
                    return CGSize(width: 174, height: 102)
                }
    }


}
