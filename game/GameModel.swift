//
//  GameModel.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/5/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
class GameModel {
    enum TouchMode {
        case flag
        case normal
    }
    
    enum Difficult {
        case easy
        case normal
        case hard
    }
    
    var difficultMaxMine: [Difficult: Int] = [.easy: 10,
                                                       .normal: 8,
                                                       .hard: 5]
    var flagImage: [TouchMode: String] = [.normal: "flagging", .flag: "flagged"]
    
    private var _score = 0 {
        didSet {
            scoreUpdate?(_score)
        }
    }
    var score: Int {
        set { _score = newValue }
        get { return _score }
    }
    var scoreUpdate: ((_ score: Int) -> Void)?
    
    private var _touchMode: TouchMode = .normal {
        didSet {
            touchModeUpdate?(_touchMode)
        }
    }
    var touchMode: TouchMode {
        get { return _touchMode }
    }
    var touchModeUpdate: ((_ mode: TouchMode) -> Void)?
    func toggleFlag() {
        if _touchMode == .normal {
            _touchMode = .flag
        }
        else {
            _touchMode = .normal
        }
    }
    
    //TODO: Tao 1 enum chua cac state cua game
    var gameState: Bool = false {
        didSet {
            isOver?(gameState)
        }
    }
    var isOver: ((_ state: Bool) -> Void)?
    
    static let shareInstance = GameModel()
    
    init() {
        _touchMode = .normal
        _score = 0
    }
}
