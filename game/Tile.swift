//
//  Tile.swift
//  game
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import Foundation
class Tile {
    enum Status {
        case hide
        case opened
        case flagged
        case marked
        case flagging
        case exploded
    }
    
    var imageDictionary: [Status: String] = [.hide: "hidden", .opened: "opened", .flagged: "flagged", .marked: "marked", .flagging: "flagging", .exploded: "exploded"]
    
    var y: Int
    var x: Int
    
    var mineCounter: Int
    var status: Status
    var isMine: Bool
    
    init(x: Int, y: Int) {
        self.y = y
        self.x = x
        
        mineCounter = 0
        isMine = false
        status = .hide
    }
    init() {
        self.x = 0
        self.y = 0
        
        mineCounter = 0
        isMine = false
        status = .hide
    }
}
