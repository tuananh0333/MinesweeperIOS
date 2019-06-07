//
//  Tile.swift
//  Minesweeper
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
        case exploded
    }

    private var imageDictionary: [State: String] = [.hide: "hidden", .opened: "opened", .flagged: "flagged", .marked: "marked", .exploded: "exploded"]
    
    private var _y: Int
    private var _x: Int
    
    private var _mineCounter: Int
    private var _state: State {
        didSet {
            _imageName = imageDictionary[_state]!
            if _state == .opened {
                _imageName.append("\(_mineCounter)")
            }
        }
    }
    
    private var _isMine: Bool
    private var _imageName: String
    
    init(_ x: Int, _ y: Int) {
        self._y = y
        self._x = x
        
        self._mineCounter = 0
        self._isMine = false
        self._state = .hide
        _imageName = imageDictionary[_state]!
    }
    
    init() {
        self._x = 0
        self._y = 0
        
        self._mineCounter = 0
        self._isMine = false
        self._state = .hide
        _imageName = imageDictionary[_state]!
    }
    
    var x: Int {
        set { _x = newValue }
        get { return _x }
    }
    
    var y: Int {
        set { _y = newValue }
        get { return _y }
    }
    
    var mineCounter: Int {
        get { return _mineCounter }
    }
    
    func increaseMineCounter(by: Int) {
        if _isMine {
            return
        }
        if by < 0 {
            return
        }
        self._mineCounter += by
    }
    
    var state: State {
        set { _state = newValue }
        get { return _state }
    }
    
    var isMine: Bool {
        set { _isMine = newValue }
        get { return _isMine }
    }
    
    func openTile() {
        if _state == .hide {
            if (_isMine) {
                _state = .exploded
            }
            else {
                _state = .opened
            }
        }
    }
    
    func flagTile() {
        switch _state {
        case .hide:
            _state = .flagged
        case .flagged:
            _state = .marked
        case .marked:
            _state = .hide
        default:
            break
        }
    }
    
    var imageName: String? {
        get { return _imageName }
    }
    
    // Need a Postition class for better using
    var pos: String {
        get { return "(\(_x), \(_y))" }
    }
}
