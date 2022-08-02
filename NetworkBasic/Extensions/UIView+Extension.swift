//
//  UIView+Extension.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/01.
//

import UIKit

extension UIView {
    
    func makeCircle() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = .systemYellow
        
    }
    
}
