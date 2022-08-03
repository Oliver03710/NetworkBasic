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
        configureCells()
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
                
                self.collectionView.reloadData()
                
                print(self.totalBeers)
                print(self.totalBeers[0].image)
                print(self.totalBeers[0].beersName)
                print(self.totalBeers[0].description)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

    func configureCells() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.4)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
    }
    
}




// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource

extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalBeers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.reuseIdentifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        cell.beerImageView.kf.setImage(with: totalBeers[indexPath.row].image)
        cell.beerImageView.contentMode = .scaleAspectFit
        
        cell.beerName.text = totalBeers[indexPath.row].beersName
        cell.beerName.textAlignment = .center
        cell.beerName.font = .boldSystemFont(ofSize: 15)
        
        cell.beerDescription.text = totalBeers[indexPath.row].description
        cell.beerDescription.font = .systemFont(ofSize: 13)
        
        return cell
        
    }

}
