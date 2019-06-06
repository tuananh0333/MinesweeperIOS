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
        case exploded
    }

    private var _imageName: [State: String] = [.hide: "hidden", .opened: "opened", .flagged: "flagged", .marked: "marked", .exploded: "exploded"]
    
    private var _y: Int
    private var _x: Int
    
    private var _mineCounter: Int
    private var _state: State
    private var _isMine: Bool
    var isOpened: Bool
    
    init(_ x: Int, _ y: Int) {
        self._y = y
        self._x = x
        
        self._mineCounter = 0
        self._isMine = false
        self.isOpened = false
        self._state = .hide
    }
    
    init() {
        self._x = 0
        self._y = 0
        
        self._mineCounter = 0
        self._isMine = false
        self.isOpened = false
        self._state = .hide
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
    
    
    func touch(touchMode: BoardModel.TouchMode) {
        switch touchMode {
        case .flag:
            flagTile()
        case .normal:
            openTile()
        }
    }
    
    private func openTile() {
        if _state == .hide {
            if (_isMine) {
                _state = .exploded
            }
            else {
                _state = .opened
            }
        }
    }
    
    private func flagTile() {
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
        get {
            if var imageName = _imageName[_state] {
                if _state == .opened {
                    imageName.append("\(_mineCounter)")
                }
                return imageName
            }
            else {
                return nil
            }
        }
    }
    
    // Need a Postition class for better using
    var pos: String {
        get { return "(\(_x), \(_y))" }
    }
}
