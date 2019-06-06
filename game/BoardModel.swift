//
//  BoardModel.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/3/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
class BoardModel {
    enum TouchMode {
        case flag
        case normal
    }
    enum Difficult {
        case easy
        case normal
        case hard
    }
    enum GameState {
        case win
        case playing
        case over
    }
    
    //MARK: Fields
    private var _rows: Int = 16
    private var _cols: Int = 8
    private var _minesAmount = 0
    private var _maxMines = 0
    private var _openedTiles = 0
    private var _flaggedTiles = 0
    private var _flaggedMine = 0
    private var _tilesList: [[TileControl]] = []
    
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

    var gameState: GameState = .playing {
        didSet {
            isOver?(gameState)
        }
    }
    var isOver: ((_ state: GameState) -> Void)?
    
    static let shareInstance = BoardModel()
    
    var difficultMaxMine: [Difficult: Int] = [.easy: 10, .normal: 8, .hard: 5]
    private var _nearbyTileOffset: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    
    init() {
        resetBoardProperties()
        setupTileField()
    }
    
    func setBoardSize(rows: Int = 16, cols: Int = 8) {
        self._rows = rows
        self._cols = cols

        resetBoardProperties()
        setupTileField()
    }
    
    private func resetBoardProperties() {
        _maxMines = 0
        _minesAmount = 0
        gameState = .playing
        _touchMode = .normal
        _score = 0
    }
    
    //MARK: Prepare data
    func setupTileField() {
        resetTilesList()
        generateMine()
        
        for x in 0 ..< _cols {
            for y in 0 ..< _rows {
                countMinesAround(tile: _tilesList[x][y])
            }
        }
    }
    
    private func resetTilesList() {
        _tilesList = []
        for x in 0 ..< _cols {
            _tilesList.append([])
            
            for y in 0 ..< _rows {
                let btnTile = TileControl()
                btnTile.setTileModel(Tile(x, y))
                
                _tilesList[x].append(btnTile)
            }
        }
    }
    
    // If maxMines is not set (0 be default), mines amount is not stable
    // If maxMines is set, keep generating until mines amount equal max Mine
    // If a tile is a mine tile, increase mines amount
    func generateMine() {
        repeat {
            for x in 0 ..< _cols {
                for y in 0 ..< _rows {
                    let selectedTile = _tilesList[x][y]
                    selectedTile.setMine(chance: 5)
                    if selectedTile.getTileModel().isMineTile() {
                        _minesAmount += 1
                    }
                }
            }
        } while (_minesAmount < _maxMines)
    }
    
    // Not counting if:
    // - tile is a mine tile
    // - there is no tile near it
    // If there is a mine tile near it: increase it's mine counter
    func countMinesAround(tile: TileControl) {
        if tile.getTileModel().isMineTile() {
            return
        }
        
        let nearbyTiles: [TileControl] = getNearbyTiles(of: tile)
        
        for nearbyTile in nearbyTiles {
            if (nearbyTile.getTileModel().isMineTile()) {
                tile.getTileModel().increaseMineCounter(by: 1)
            }
        }
    }
    
    func getNearbyTiles(of: TileControl) -> [TileControl] {
        var nearbyTiles: [TileControl] = []
        
        for (rowOffset, colOffset) in _nearbyTileOffset {
            if let nearbyTile = getTileAt(of.getTileModel().getX() + rowOffset, of.getTileModel().getY() + colOffset) {
                nearbyTiles.append(nearbyTile)
            }
        }
    
        return nearbyTiles
    }
    
    // Return nil if tile(x, y) is outside the board
    func getTileAt(_ x: Int, _ y: Int) -> TileControl? {
        let xRange = 0 ..< _cols
        let yRange = 0 ..< _rows
        
        if xRange.contains(x) && yRange.contains(y) {
            return _tilesList[x][y]
        }
        
        return nil
    }

    // This function is too big
    func touch(_ tile: TileControl) {
        // Check if reach maximum flag and mark
        if touchMode == .flag && _flaggedTiles == _minesAmount && tile.getTileModel().getState() == .hide {
            print("You have reach maximum flagged")
            return
        }
        
        tile.touchTile(touchMode: touchMode)
        
        let state = tile.getTileModel().getState()
        
        switch state {
        case .opened:
            // Expand if no mine around
            if tile.getTileModel().getMineCounter() <= 0 {
                let nearbyTiles = getNearbyTiles(of: tile)
                
                for nearbyTile in nearbyTiles {
                    // Countinue expand if nearby tile is touchable and has no mine around it
                    if nearbyTile.isTouchable() && nearbyTile.getTileModel().getMineCounter() == 0 {
                        touch(nearbyTile)
                    }
                    else {
                        nearbyTile.touchTile(touchMode: touchMode)
                    }
                }
            }
            
            // Increase score
            _openedTiles += 1
            print(score)
            
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
        // If all "not mine" tile is opened
        if _rows * _cols - _openedTiles == _minesAmount {
            return true
        }
        
        // If all mine tile is flagged
        if _flaggedMine == _minesAmount {
            return true
        }
        
        return false
    }
    
    func win() {
        gameState = .win
        score += _maxMines * 5
    }
    
    func gameOver() {
        gameState = .over
        score += _flaggedMine * 5
        
        for x in 0 ..< _cols {
            for y in 0 ..< _rows {
                if _tilesList[x][y].getTileModel().isMineTile() {
                    _tilesList[x][y].end()
                }
            }
        }
    }
}
