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
    
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    
    // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음!
    var lottoPickerView = UIPickerView()
    
    var numberList: [Int] = Array(1...LottoCal.currentDraw()).reversed()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.tintColor = .clear
        numberTextField.inputView = lottoPickerView
        numberTextField.delegate = self
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        configureUI()
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        numberLabels.forEach { $0.setLabels() }
        ballView.forEach { $0.makeCircle() }
    }
    
    
    func checkLottoInfo(drawNum: Int) {
        
        if UserdefaultsHelper.standard.drawNums[drawNum] != nil {
            guard let winningNum = UserdefaultsHelper.standard.drawNums[drawNum] else { return }
            
            for i in 0..<winningNum.count {
                numberLabels[i].text = winningNum[i]
            }
            
        } else {
            requestLotto(number: drawNum)
        }
        
        
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation {
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    // MARK: - Networking
    
    func requestLotto(number: Int) {
        
        LottoAPIManager.shared.fetcLottoData(drawNum: number) { drawNumber, winningNums in
            
            UserdefaultsHelper.standard.drawNums.updateValue(winningNums, forKey: drawNumber)
            print("네트워킹")
            
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
        checkLottoInfo(drawNum: numberList[row])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    

    
}
