//
//  UserDefaultsHelper.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/01.
//

import UIKit

class UserdefaultsHelper {
    
    private init() { }
    
    // singleton pattern: 자기 자신의 인스턴스를 하나만 찍어두고 필요할 때만 불러서 썼다가 메모리에서 내렸다가 반복, 자기자신의 인스턴스를 타입 프로퍼티 형태로 가지고 있음
    static let standard = UserdefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case nickname, age, date
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {   // 연산 프로퍼티 parameter
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
    var date: Int {
        get {
            return userDefaults.integer(forKey: Key.date.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.date.rawValue)
        }
    }
    
    func reset() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
    
}
