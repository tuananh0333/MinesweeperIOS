//
//  Tile.swift
//  game
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import Foundation
class Tile {
    enum State {
        case hide
        case opened
        case flagged
        case marked
        case flagging
        case exploded
    }

    enum Trigger {
        case openTile
        case flagTile
    }

    private var imageDictionary: [State: String] = [.hide: "hidden",
                                             .opened: "opened",
                                             .flagged: "flagged",
                                             .marked: "marked",
                                             .flagging: "flagging",
                                             .exploded: "exploded"]
    
    private var y: Int
    private var x: Int
    
    private var mineCounter: Int
    private var state: State
    private var isMine: Bool
    
    init(x: Int, y: Int) {
        self.y = y
        self.x = x
        
        self.mineCounter = 0
        self.isMine = false
        self.state = .hide
    }
    
    init() {
        self.x = 0
        self.y = 0
        
        self.mineCounter = 0
        self.isMine = false
        self.state = .hide
    }
    
    func getX() -> Int {
        return self.x
    }
    
    func setX(_ x: Int) {
        self.x = x < 0 ? -1 : x
    }
    
    func getY() -> Int {
        return self.y
    }
    
    func setY(_ y: Int) {
        self.y = y < 0 ? -1 : y
    }
    
    func getMineCounter() -> Int {
        return mineCounter
    }
    
    func increaseMineCounter(by: Int) {
        if isMine {
            return
        }
        else {
            self.mineCounter += by < 0 ? 0 : by
        }
    }
    
    func setMineCounter(value: Int) {
        if (value <= 0) {
            self.mineCounter = 0
        } else if (value >= 9) {
            self.mineCounter = 9
        } else {
            self.mineCounter = value
        }
        
//        self.mineCounter = value <= 0 ? 0 : (value >= 9 ? 9 : value)
    }
    
    func getState() -> State {
        return self.state
    }
    
    func setState(_ state: State) {
        self.state = state
    }
    
    func setMine(_ value: Bool) {
        self.isMine = value
    }
    
    func isMineTile() -> Bool {
        return self.isMine
    }
    
    func touched(touchMode: BoardModel.TouchMode) -> State {
        switch touchMode {
        case .flag:
            flagTile()
        case .normal:
            openTile()
        }

        return state
    }
    
    private func openTile() {
        if state == .hide {
            if (isMine) {
                state = .exploded
            }
            else {
                state = .opened
            }
        }
    }
    
    private func flagTile() {
        switch state {
        case .hide:
            state = .flagged
        case .flagged:
            state = .marked
        case .marked:
            state = .hide
        case .opened:
            break
        case .flagging:
            break
        case .exploded:
            break
        }
    }
    
    func getImageName() -> String? {
        return imageDictionary[state]! + getChildImage()
    }
    
    private func getChildImage() -> String {
        return mineCounter == 0 ? "" : mineCounter.description
    }
}
