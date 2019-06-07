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
    private var _maxMines = 0
    private var _openedTiles = 0
    private var _flaggedMine = 0
    
    private var _mineTilesList: [TileControl] = []
    private var _tilesList: [[TileControl]] = []
    
    var tileList: [[TileControl]] {
        get { return _tilesList }
    }
    
    var rows: Int {
        set { _rows = newValue }
        get { return _rows }
    }
    
    var cols: Int {
        set { _cols = newValue }
        get { return _cols }
    }
    
    var difficult: Difficult = .easy {
        didSet {
            
        }
    }
    
    private var _minesAmount = 0
    var mineAmount: Int {
        get { return _minesAmount }
    }
    
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
    
    private var _flaggedTiles = 0 {
        didSet {
            flaggedTilesChanged?(_flaggedTiles)
        }
    }
    var flaggedTilesChanged: ((_ tilesCount: Int) -> Void)?
    
    
    
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
    
    func resetBoardProperties() {
        _maxMines = 0
        _minesAmount = 0
        gameState = .playing
        _touchMode = .normal
        _score = 0
    }
    
    //MARK: Prepare data
    func setupTileField() {
        resetTilesList()
        
        if _maxMines == 0 {
            generateMine(chance: 10)
        }
        else {
            generateMine(maxMine: _maxMines)
        }
        
        if _mineTilesList.count > 0 {
            for mineTile in _mineTilesList {
                countMinesAround(tile: mineTile)
            }
        }
    }
    
    private func resetTilesList() {
        _tilesList = []
        for x in 0 ..< _cols {
            _tilesList.append([])
            
            for y in 0 ..< _rows {
                let btnTile = TileControl()
                btnTile.tileModel.x = x
                btnTile.tileModel.y = y
                
                _tilesList[x].append(btnTile)
            }
        }
    }
    
    // If maxMines is not set (0 be default), mines amount is not stable
    // If maxMines is set, keep generating until mines amount equal max Mine
    // If a tile is a mine tile, increase mines amount
    func generateMine(chance: Int) {
        for x in 0 ..< _cols {
            for y in 0 ..< _rows {
                if let selectedTile = getTileAt(x, y) {
                    if !selectedTile.tileModel.isMine {
                        selectedTile.setMine(chance: Float(chance))
                        if selectedTile.tileModel.isMine {
                            _minesAmount += 1
                            _mineTilesList.append(selectedTile)
                        }
                    }
                }
            }
        }
        
        print("Mines amount: ", _minesAmount)
    }
    
    func generateMine(maxMine: Int) {
        repeat {
            let x = arc4random_uniform(UInt32(_cols - 1))
            let y = arc4random_uniform(UInt32(_rows - 1))
            if let selectedTile = getTileAt(Int(x), Int(y)) {
                if !selectedTile.tileModel.isMine {
                    selectedTile.setMine()
                    _minesAmount += 1
                    _mineTilesList.append(selectedTile)
                }
            }
        } while (_minesAmount < _maxMines)

        print("Mines amount: ", _minesAmount)
    }

    // Not counting if:
    // - tile is a mine tile
    // - there is no tile near it
    // If there is a mine tile near it: increase it's mine counter
    func countMinesAround(tile: TileControl) {
        var nearbyTiles: [TileControl] = getNearbyTiles(of: tile)
        
        tile.increaseAffectedTilesMineCounter(tilesList: &nearbyTiles)
        
        print("countMinesAround() - Tile \(tile.tileModel.pos)")
    }
    
    func getNearbyTiles(of: TileControl) -> [TileControl] {
        var nearbyTiles: [TileControl] = []
        
        for (rowOffset, colOffset) in _nearbyTileOffset {
            if let nearbyTile = getTileAt(of.tileModel.x + rowOffset, of.tileModel.y + colOffset) {
                nearbyTiles.append(nearbyTile)
            }
        }
        
        print("getNearbyTiles() - Affected Tiles: ", nearbyTiles.count)
        return nearbyTiles
    }
    
    // Return nil if tile(x, y) is outside the board
    func getTileAt(_ x: Int, _ y: Int) -> TileControl? {
        let xRange = 0 ..< _cols
        let yRange = 0 ..< _rows
        
        if xRange.contains(x) && yRange.contains(y) {
            let selectedTile = _tilesList[x][y]
            
            return selectedTile
        }
        
        return nil
    }

    // This function is too big
    func touch(_ tile: TileControl) {
        if isWin() {
            win()
        }
        
        switch _touchMode {
        case .flag:
            // Check if reach maximum flag and mark
            if _flaggedMine == _mineTilesList.count {
                print("You have reach maximum flagged")
                return
            }
            
            tile.flagTile()
            
            
            if tile.tileModel.state == .flagged {
                _flaggedTiles += 1
                
                if tile.tileModel.isMine {
                    _flaggedMine += 1
                }
            }

            if tile.tileModel.state == .marked {
                _flaggedTiles -= 1
                
                if tile.tileModel.isMine {
                    _flaggedMine -= 1
                }
            }
            
        case .normal:
            tile.openTile()
            
            if tile.tileModel.state == .exploded {
                gameOver()
            } else {
                _openedTiles += 1
                
                // Expand if no mine around
                if tile.tileModel.mineCounter > 0 {
                    return
                }
                
                let nearbyTiles = getNearbyTiles(of: tile)
                
                for nearbyTile in nearbyTiles {
                    // Countinue expand if nearby tile is touchable and has no mine around it
                    if nearbyTile.tileModel.mineCounter == 0 && nearbyTile.isEnabled {
                        touch(nearbyTile)
                    }
                    else {
                        nearbyTile.openTile()
                    }
                }
            }
        }
    }
    
    // Win if flagged tiles > 0 (aka: User doesn't mass flag every tile on the board) and:
    // - User open every "not mine" tiles
    // Or: - user flagged every mine tiles
    func isWin() -> Bool{
        if (_flaggedTiles > 0) {
            // If all "not mine" tile is opened
            if _rows * _cols - _openedTiles == _minesAmount {
                return true
            }
            
            // If all mine tile is flagged
            if _flaggedMine == _minesAmount {
                return true
            }
        }
        return false
    }
    
    func win() {
        gameState = .win
        score += _flaggedMine * 5
    }
    
    func gameOver() {
        gameState = .over
        score += _flaggedMine * 5
        
        for x in 0 ..< _cols {
            for y in 0 ..< _rows {
                if let currentTile = getTileAt(x, y) {
                    if currentTile.tileModel.isMine {
                        currentTile.end()
                    }
                }
            }
        }
    }
}
