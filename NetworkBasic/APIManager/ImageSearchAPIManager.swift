//
//  ImageSearchAPIManager.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class ImageSearchAPIManager {
    
    private init() { }
    
    static let shared = ImageSearchAPIManager()
    
    typealias completionHandler = (Int, [String]) -> Void
    
    // fetch, request, callRequest, get ... -> response에 따라 네이밍을 설정해주기도 함
    // pagenation
    // @escaping -> completionHandler가 fetchImageData에서 탈출하여 다른 곳에서 사용되기 때문에 파라미터 앞쪽에 작성해야 한다.
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping completionHandler) {
        
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total"].intValue
                
//                for image in json["items"].arrayValue {
//                    // 셀에서 URL, UIImage 변환을 할 건지
//                    // 서버통신을 받는 시점에서 URL, UIImage 변환을 할 건지 -> 시간이 오래 걸림
//                    self.imageArr.append(image["thumbnail"].stringValue)
//                }
                
                let list = json["items"].arrayValue.map { $0["thumbnail"].stringValue }

                    completionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
            }
        }
    
    }
    
}
