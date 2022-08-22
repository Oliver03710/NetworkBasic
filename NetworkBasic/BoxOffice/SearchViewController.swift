//
//  SearchViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/27.
//

import UIKit

import Alamofire
import JGProgressHUD
import RealmSwift
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔 / 오른팔 가져오기
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

/*
 각 json value -> list -> 테이블뷰 갱신
 
 let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
 let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
 let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
 
 // list 배열에 데이터 추가
 self.list.append(movieNm1)
 self.list.append(movieNm2)
 self.list.append(movieNm3)
 
 서버의 응답이 몇 개인지 모를 경우에는?
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // BoxOffice 배열
    
    var list: [BoxOfficeModel] = []
    let hud = JGProgressHUD()
    
    let today = Date()
    let formatter = DateFormatter()
    let localRealm = try! Realm()
    var tasks: Results<MovieArchive>!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 연결고리 작업: 테이블뷰가 해야 할 역할 -> 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // 테이블 뷰가 사용할 테이블 뷰 셀 등록(XIB 사용시)
        // XIB: xml interface builder, (구)NIB
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        
        searchBar.delegate = self
        tasks = localRealm.objects(MovieArchive.self).sorted(byKeyPath: "raking", ascending: true)
        if let arr = tasks {
            if !arr[arr.count].inputDate.contains(calculatingDate()) {
                requestBoxOffice(text: calculatingDate())
            }
        }
        
        
    }
    
    
    // MARK: - Networking
    
    func requestBoxOffice(text: String) {
        
        hud.show(in: self.view)

        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                print("Networking...")
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieTitle = movie["movieNm"].stringValue
                    let rank = movie["rank"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let task = MovieArchive(movieTitle: movieTitle, raking: rank, releaseDate: openDt, totalAudience: audiAcc, inputDate: self.calculatingDate())
                    
                    try! self.localRealm.write {
                        self.localRealm.add(task)
                        print("Realm Succeed")
                    }
                    
                }
                
                // 테이블뷰 갱신
                self.searchTableView.reloadData()
                self.hud.dismiss(animated: true)
                
            case .failure(let error):
                self.hud.dismiss(animated: true)
                print(error)
            }
        }
        
    }
    
    
    // MARK: - Helper Functions
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 200
    }
    
    
    func calculatingDate() -> String {
        
        formatter.dateFormat = "yyyyMMdd"
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return "" }
        return formatter.string(from: yesterday)
        
    }
    
    
    // MARK: - Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.setUI()
        cell.titleLabel.text = tasks[indexPath.row].movieTitle
        cell.rankingLabel.text = tasks[indexPath.row].raking
        cell.releaseDateLabel.text = tasks[indexPath.row].releaseDate
        cell.totalAudienceLabel.text = tasks[indexPath.row].totalAudience
        
        return cell
    }
}


// MARK: - Extension: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
            requestBoxOffice(text: text)
    }
    
}
