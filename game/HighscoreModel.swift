//
//  HighscoreModel.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/7/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
class HighscoreModel {
    var value: Int
    var date: Date
    
    init(value: Int, date: Date) {
        self.value = value
        self.date = date
    }
}
