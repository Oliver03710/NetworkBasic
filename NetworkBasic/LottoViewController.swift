//
//  LottoViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet var ballView: [UIView]!
    @IBOutlet var numberLabels: [UILabel]!
    @IBOutlet weak var bonusNumLabel: UILabel!
    
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    var lottoPickerView = UIPickerView()
    // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음!
    
    var numberList: [Int] = Array(1...LottoCal.currentDraw()).reversed()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.tintColor = .clear
        numberTextField.inputView = lottoPickerView
        numberTextField.delegate = self
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: numberList.count)
        configureUI()
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        
        for i in numberLabels {
            i.setLabels()
        }
        
        bonusNumLabel.setLabels()
        
        for i in ballView {
            i.makeCircle()
        }
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func requestLotto(number: Int) {

        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        
        //AF: 200~299 status code - Success
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let bonus =  json["bnusNo"].stringValue
                self.bonusNumLabel.text = bonus
                print(bonus)
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                var drawNum = [String]()
                
                for i in 1...6 {
                    drawNum.append(json["drwtNo\(i)"].stringValue)
                    self.numberLabels[i - 1].text = drawNum[i - 1]
                }
                print(drawNum)
                
                self.numberTextField.text = date
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - extension: UIPickerViewDelegate, UIPickerViewDataSource

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    

    
}
