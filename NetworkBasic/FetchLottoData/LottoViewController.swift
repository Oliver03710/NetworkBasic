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
    @IBOutlet weak var InstructionLabel: UILabel!
    
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
        configureNumLabels()
        configureBallViews()
    }
    
    
    func configureNumLabels() {
        numberLabels.forEach { $0.setLabels() }
    }
    
    
    func configureBallViews() {
        ballView.forEach { $0.makeCircle() }
    }
    
    
    func setBallColors() {
        for i in 0..<numberLabels.count {
            
            numberLabels[i].textColor = .black
            guard let text = numberLabels[i].text else { return }
            guard let intText = Int(text) else { return }
            
            switch intText {
            case let x where x / 10 == 0: ballView[i].backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            case let x where x / 10 == 1: ballView[i].backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            case let x where x / 10 == 2: ballView[i].backgroundColor = #colorLiteral(red: 0.9096854329, green: 0.4343447089, blue: 0.4038938284, alpha: 1)
            case let x where x / 10 == 3: ballView[i].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case let x where x / 10 == 4: ballView[i].backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            default: ballView[i].backgroundColor = .systemBackground
            }
        }
    }
    
    
    func checkLottoInfo(drawNum: Int) {
        
        if UserdefaultsHelper.standard.drawNums[drawNum] != nil {
            
            guard let winningNum = UserdefaultsHelper.standard.drawNums[drawNum] else { return }
            for i in 0..<winningNum.count {
                numberLabels[i].text = winningNum[i]
            }
            setBallColors()
            
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
            
            DispatchQueue.main.async {
                for i in 0..<winningNums.count {
                    self.numberLabels[i].text = winningNums[i]
                }
                self.setBallColors()
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
        checkLottoInfo(drawNum: numberList[row])
        InstructionLabel.text = "선택한 회차는 \(numberList[row])차입니다."
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    

    
}
