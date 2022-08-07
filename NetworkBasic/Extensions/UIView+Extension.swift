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
        self.layer.cornerRadius = self.layer.bounds.height / 2
        
    }
    
}
