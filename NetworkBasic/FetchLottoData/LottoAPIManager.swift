//
//  LottoAPIManager.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/07.
//

import Foundation

import Alamofire
import SwiftyJSON

class LottoAPIManager {
    
    private init() { }
    
    static let shared = LottoAPIManager()
    
    typealias completionHandler = (Int, [String]) -> Void
    
    func fetcLottoData(drawNum: Int, completionHandler: @escaping completionHandler) {
        
        let url = "\(EndPoint.lottoURL)&drwNo=\(drawNum)"
        
        //AF: 200~299 status code - Success
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")

                let draw = json["drwNo"].intValue
                
                var winningNumbers = [String]()
                
                for i in 1...6 {
                    winningNumbers.append(json["drwtNo\(i)"].stringValue)
                }
                winningNumbers.append(json["bnusNo"].stringValue)
                
                completionHandler(draw, winningNumbers)
                
            case .failure(let error):
                print(error)
            }
        }
    
    }
    
}
