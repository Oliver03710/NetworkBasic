//
//  ViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol {
   
    // MARK: - Properties
    
    var navigationTitleString: String {
        get {
            return "대장님의 다마고치"
        }
        set {
            title = newValue
        }
    }
    var backgroundColor: UIColor {
        get {
            return .blue
        }
    }
    static let identifier: String =  ""
    

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        UserdefaultsHelper.standard.nickname = "고래밥"
        title = UserdefaultsHelper.standard.nickname
    }

   
    // MARK: - Helper Functions
    
    func configureView() {
        
        navigationTitleString = "고래밥님의 다마고치"
//        backgroundColor = .red
        
        title = navigationTitleString
        view.backgroundColor = backgroundColor
    }
}
