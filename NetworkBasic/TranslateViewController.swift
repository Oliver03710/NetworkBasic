//
//  TranslateViewController.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

// UIButton, UITextField -> Action 가능
// UITextView, UISearchBar, UIPickerView -> Action 불가
// UIControl
// UIResponderChain -> resignFirstResponder() / becomeFirstResponder()

class TranslateViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextView.delegate = self
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        userInputTextView.font = UIFont(name: "Happiness-Sans-Regular", size: 17)
        userInputTextView.layer.borderWidth = 1
        userInputTextView.layer.borderColor = UIColor.gray.cgColor
        
        outputTextView.layer.borderWidth = 1
        outputTextView.layer.borderColor = UIColor.red.cgColor
        outputTextView.font = UIFont(name: "Happiness-Sans-Regular", size: 17)
    }
    
    
    // MARK: - Networking
    
    func requestTranslatedData(inputText: String) {
        
        let url = EndPoint.translateURL

        let parameter = ["source": "ko", "target": "en", "text": inputText]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.outputTextView.text = json["message"]["result"]["translatedText"].stringValue
                } else {
                    self.outputTextView.text = json["errorMessage"].stringValue
                }
                

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.reuseIdentifier) as? WebViewController else { return }
//        vs.modalPresentationStyle = .
        self.present(vc, animated: true)
        
    }
    
    
    @IBAction func TranslatingButtonTapped(_ sender: UIButton) {
        
        guard let text = userInputTextView.text else { return }
        requestTranslatedData(inputText: text)
        
    }
    
}


extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    
    // 편집이 시작될 때
    // 텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear, Color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝났을 떄, 커서가 없어지는 순간
    // 텍스트뷰 글자: 사용자가 아무 글자도 안 썼으면 플레이스 홀더 글자 보이게
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}
