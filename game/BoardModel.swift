//
//  BoardModel.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/3/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
class BoardModel {
    enum NearbyTileFilterType {
        case square
        case plus
    }
    enum TouchMode {
        case flag
        case normal
    }
    enum Difficult {
        case easy
        case normal
        case hard
    }
    
    //MARK: Fields
    private var _rows: Int = 16
    private var _cols: Int = 8
    private var _minesAmount = 0
    private var _maxMines = 0
    private var _openedTiles = 0
    private var _flaggedTiles = 0
    private var _flaggedMine = 0
    private var _tilesField: [[TileControl]] = []
    
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
    
    private var _touchMode: TouchMode {
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
    // false: Chua thua
    // true: da thua
    var gameState: Bool = false {
        didSet {
            isOver?(gameState)
        }
    }
    var isOver: ((_ state: Bool) -> Void)?
    
    static let shareInstance = BoardModel()
    
    var difficultMaxMine: [Difficult: Int] = [.easy: 10,
                                              .normal: 8,
                                              .hard: 5]
    private var _nearbyTileOffset: [NearbyTileFilterType: [(Int, Int)]] = [.plus: [(0, -1), (-1, 0), (1, 0), (0, 1)],
                                                                           .square: [(-1, -1), (0, -1), (1, -1),
                                                                                     (-1, 0), (1, 0),
                                                                                     (-1, 1), (0, 1), (1, 1)]]
    
    init() {
        _maxMines = 0
        _minesAmount = 0
        gameState = false
        _touchMode = .normal
        _score = 0
        
        setupTileField()
    }
    
    func setBoardSize(rows: Int = 16, cols: Int = 8) {
        self._rows = rows
        self._cols = cols

        _maxMines = 0
        _minesAmount = 0
        gameState = false
        
        setupTileField()
    }
    
    //MARK: Prepare data
    func setupTileField() {
        _tilesField = []
        for x in 0 ..< _cols {
            _tilesField.append([])
            
            for y in 0 ..< _rows {
                let btnTile = TileControl()
                btnTile.setTileModel(Tile(x, y))
                
                _tilesField[x].append(btnTile)
            }
        }

        generateMine()
        
        for x in 0 ..< _cols {
            for y in 0 ..< _rows {
                countMinesAround(tile: _tilesField[x][y])
            }
        }
    }
    
    func generateMine() {
        repeat {
            for x in 0 ..< _cols {
                for y in 0 ..< _rows {
                    setMineForTile(tile: _tilesField[x][y])
                }
            }
        } while (_minesAmount < _maxMines)
    }

    func setMineForTile(tile: TileControl) {
        let tileModel = tile.getTileModel()
        
        if tileModel.isMineTile() {
            return
        }
        
        var percent: Bool = false
        if self._maxMines != 0 {
            percent = ((arc4random() % UInt32(_maxMines)) == 0)
        }
        else {
            percent = (arc4random_uniform(5) == 0)
        }
        
        if percent == true {
            tileModel.setMine(true)
            _minesAmount += 1
            print("Mine: ",tileModel.getX(), ",", tileModel.getY(), "")
        }
        
        tile.setTileModel(tileModel)
    }
    
    func countMinesAround(tile: TileControl) {
        if tile.getTileModel().isMineTile() {
            return
        }
        
        guard let nearbyTiles: [TileControl] = getNearbyTiles(of: tile, type: .square) else {
            return
        }
        
        for nearbyTile in nearbyTiles {
            if (nearbyTile.getTileModel().isMineTile()) {
                tile.getTileModel().increaseMineCounter(by: 1)
            }
        }
    }
    
    func getNearbyTiles(of: TileControl, type: NearbyTileFilterType) -> [TileControl]? {
        guard let offsets = _nearbyTileOffset[type] else {
            print(type, " not found!")
            return nil
        }
        
        var nearbyTiles: [TileControl] = []
        for (rowOffset, colOffset) in offsets {
            if let nearbyTile = getTileAt(of.getTileModel().getX() + rowOffset, of.getTileModel().getY() + colOffset) {
                var condition: Bool = true
                if type == .plus {
                    condition = !nearbyTile.getTileModel().isMineTile() && nearbyTile.getTileModel().getState() == .hide
                }
                
                if condition {
                    nearbyTiles.append(nearbyTile)
                }
            }
        }
        
        return nearbyTiles
    }
    
    func getTileAt(_ x: Int, _ y: Int) -> TileControl? {
        if (x >= 0 && x < self._cols
            && y >= 0 && y < self._rows) {
            return _tilesField[x][y]
        }
        else {
            return nil
        }
    }

    func touch(_ tile: TileControl) {
        if gameState == true {
            print("Game is over")
            return
        }
        
        if isWin() {
            win()
            print("You win")
            return
        }

        if touchMode == .flag && _flaggedTiles == _minesAmount {
            print("You have reach maximum flagged")
            return
        }
        
        let state = tile.touch(touchMode: touchMode)
        
        switch state {
        case .opened:
            // Expand if no mine around
            if tile.getTileModel().getMineCounter() <= 0 {
                guard let nearbyTiles = getNearbyTiles(of: tile, type: .square) else {
                    return
                }
                
                for nearbyTile in nearbyTiles {
                    if nearbyTile.getTileModel().getState() == .hide && nearbyTile.getTileModel().getMineCounter() == 0 {
                        touch(nearbyTile)
                    }
                    else {
                        nearbyTile.touch(touchMode: touchMode)
                    }
                }
            }
            _openedTiles += 1
            score += tile.getTileModel().getMineCounter() * 2
            
        case .exploded:
            gameOver()
        case .flagged:
            _flaggedTiles += 1
            
            if tile.getTileModel().isMineTile() {
                _flaggedMine += 1
            }
        case .marked:
            _flaggedTiles -= 1
            
            if tile.getTileModel().isMineTile() {
                _flaggedMine -= 1
            }
        default:
            break;
        }
    }
    
    func isWin() -> Bool{
        if _rows * _cols - _openedTiles == _minesAmount {
            return true
        }
        
        if _flaggedMine == _minesAmount {
            return true
        }
        
        return false
    }
    
    func win() {
        score += _maxMines * 5
    }
    
    func gameOver() {
        gameState = true
        score += _flaggedMine * 5
    }
}
