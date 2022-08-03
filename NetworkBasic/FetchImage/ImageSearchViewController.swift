//
//  ImageSearchViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var fetchingImageCollectionView: UICollectionView!
    
    var imageArr: [URL] = []
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        
        fetchingImageCollectionView.delegate = self
        fetchingImageCollectionView.dataSource = self
        
        fetchingImageCollectionView.register(UINib(nibName: FetchImageCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: FetchImageCollectionViewCell.reuseIdentifier)
        
        configureCells()
    }
    
    
    // MARK: - Helper Functions
    
    func configureCells() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        fetchingImageCollectionView.collectionViewLayout = layout
    }
    
    
    // MARK: - Networking
    
    // fetch, request, callRequest, get ... -> response에 따라 네이밍을 설정해주기도 함
    // page nation 
    func fetchImage() {
        
        guard let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for image in json["items"].arrayValue {
                    
                    guard let rawImage = image["thumbnail"].url else { return }
                    
                    self.imageArr.append(rawImage)
                    
                }
                
                self.fetchingImageCollectionView.reloadData()
                
                print(self.imageArr)
                print(self.imageArr.count)

            case .failure(let error):
                print(error)
            }
        }
    }

}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FetchImageCollectionViewCell.reuseIdentifier, for: indexPath) as? FetchImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .systemGray2
        cell.searchImageVIew.kf.setImage(with: imageArr[indexPath.row])
        cell.configureFetchImageCells()
        
        return cell
        
    }

}
