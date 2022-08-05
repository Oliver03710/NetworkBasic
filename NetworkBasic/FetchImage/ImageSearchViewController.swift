//
//  ImageSearchViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

import Alamofire
import JGProgressHUD
import Kingfisher
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var fetchingImageCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var imageArr: [String] = []
    
    // 네트워크 요청시 시작할 페이지 넘버
    var startPage = 1
    var totalCount = 0
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        fetchingImageCollectionView.delegate = self
        fetchingImageCollectionView.dataSource = self
        fetchingImageCollectionView.prefetchDataSource = self
        
        fetchingImageCollectionView.register(UINib(nibName: FetchImageCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: FetchImageCollectionViewCell.reuseIdentifier)
        
        configureCells()
    }
    
    
    // MARK: - Helper Functions
    
    func configureCells() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)
        
        layout.itemSize = CGSize(width: width / 3, height: (width / 3) * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        fetchingImageCollectionView.collectionViewLayout = layout
    }
    
    
    // MARK: - Networking
    
    func fetchImage(query: String) {
        // hud.show
        ImageSearchAPIManager.shared.fetchImageData(query: query, startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.imageArr.append(contentsOf: list)
            
            DispatchQueue.main.async {
                self.fetchingImageCollectionView.reloadData()
            }
            // hud.dismiss
        }
    }

}


// MARK: - Extension: UICollectionViewDataSourcePrefetching

// 페이지네이션 방법3. 용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우 효과적
// 셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수도 있고, 필요하지 않다면 데이터를 취소 가능함
// iOS 10이상, 스크롤 성능 향상됨
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if imageArr.count - 1 == indexPath.row, imageArr.count < totalCount {
                startPage += 30
                
                guard let text = searchBar.text else { return }
                fetchImage(query: text)
            }
        }
        print("=============\(indexPaths)==============")
        
    }
    
    // 작업 취소시
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("====취소======\(indexPaths)======취소=====")
    }
    
}


// MARK: - Extension: UISearchBarDelegate

extension ImageSearchViewController: UISearchBarDelegate {
    
    // 검색 버튼 클릭 시 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            imageArr.removeAll()
            startPage = 1
            
            fetchingImageCollectionView.scrollsToTop = true
            
            fetchImage(query: text)
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageArr.removeAll()
        fetchingImageCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
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
        let url = URL(string: imageArr[indexPath.row])
        cell.searchImageVIew.kf.setImage(with: url)
        cell.configureFetchImageCells()
        
        return cell
        
    }
    
    // 페이지네이션 방법 1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막 셀에 사용자가 위치해 있는지 명확하게 확인하기 어려움 -> 권장 X
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // 페이지네이션 방법 2. UIScrollViewDelegateProtocol
    // 테이블뷰 / 컬렉션뷰 스크롤뷰를 상속받고 있어서 스크롤뷰 프로토콜을 사용할 수 있음
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//    }
    
    

}
