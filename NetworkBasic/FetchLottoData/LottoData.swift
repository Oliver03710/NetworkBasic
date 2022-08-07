//
//  LottoData.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/07.
//

import Foundation

enum LottoCal {
    
    static let today = Date()
    static let specificDate = Date(y: 2022, m: 7, d: 16)
    static var latestDraw = 1024
    
    static func currentDraw() -> Int {
        
        guard let specificDate = specificDate else { return latestDraw }
        guard let date = Calendar.current.dateComponents([.day], from: specificDate, to: today).day else { return latestDraw }
        
        if date % 7 != 0 {
            latestDraw += date / 7
            return latestDraw
        } else {
            return latestDraw
        }
    }
}
