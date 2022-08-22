//
//  RealmModel.swift
//  NetworkBasic
//
//  Created by Junhee Yoon on 2022/08/22.
//

import Foundation
import RealmSwift

class MovieArchive: Object {
    
    @Persisted var movieTitle: String
    @Persisted var raking: String
    @Persisted var releaseDate: String
    @Persisted var totalAudience: String
    @Persisted var inputDate: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(movieTitle: String, raking: String, releaseDate: String, totalAudience: String, inputDate: String) {
        self.init()
        self.movieTitle = movieTitle
        self.raking = raking
        self.releaseDate = releaseDate
        self.totalAudience = totalAudience
        self.inputDate = inputDate
        }
    
}

