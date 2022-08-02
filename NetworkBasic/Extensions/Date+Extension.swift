//
//  Date+Extension.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/02.
//

import Foundation

extension Date {

    init?(y year: Int, m month: Int, d day: Int) {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        self = date
    }
}
