//
//  Constant.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/01.
//

import Foundation

struct EndPoint {
    
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
    static let imageSearchURL = "https://openapi.naver.com/v1/search/image.json?"
    
}


//enum StoryboardName {
//    case Main
//    case Search
//    case Setting
//}

struct StoryboardNames {

    // 접근제어를 통해 초기화 방지
    private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"

}


/*
 1. struct type property vs enum type property -> enum은 인스턴스 생성이 불가, 따라서 인스턴스 생성 방지
 2. enum case vs enum static -> case의 경우 중복된 내용의 하드코딩 불가. case 제약
 */

//enum StoryboardName {
//
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//
//}

enum FontName: String {
    case title = "SanFransisco"
    case body = "SanFransisco Symbol"
    case caption = "AppleSandol"
}

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
