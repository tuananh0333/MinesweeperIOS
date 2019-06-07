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
        case demo
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
    private var _minesAmount = 0
    private var _difficult: Difficult = .easy
    
    private var _mineTilesList: [TileControl] = []
    private var _tilesList: [[TileControl]] = []
    
    
    //MARK: Properties
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
    
    var difficult: Difficult {
        set { _difficult = newValue }
        get { return _difficult }
    }
    
    var mineAmount: Int {
        get { return _minesAmount }
    }
    
    var openedTiles: Int {
        get { return _openedTiles }
        set { _openedTiles = newValue }
    }
    
    //MARK: Score delegate
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
    
    //MARK: Touchmode delegate
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

    //MARK: Gamestate delegate
    var gameState: GameState = .playing {
        didSet {
            gameStateChanged?(gameState)
        }
    }
    var gameStateChanged: ((_ state: GameState) -> Void)?
    
    //MARK: Flag tile delegate
    private var _flaggedTiles = 0 {
        didSet {
            flaggedTilesChanged?(_flaggedTiles)
        }
    }
    var flaggedTilesChanged: ((_ tilesCount: Int) -> Void)?
    
    //Define singleton instance
    static let shareInstance = BoardModel()
    
    //Dictionary
    private var _nearbyTileOffset: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    
    init() {
        resetBoardProperties()
        setupTileField()
    }
    
    func resetBoardProperties() {
        print("Difficult: ", _difficult)
        switch _difficult {
        case .easy:
            _rows = 8
            _cols = 4
            _maxMines = _rows * _cols * 3 / 10
        case .normal:
            _rows = 16
            _cols = 8
            _maxMines = _rows * _cols * 2 / 10
        case .hard:
            _rows = 32
            _cols = 16
            _maxMines = _rows * _cols * 2 / 10
        case .demo:
            _rows = 16
            _cols = 8
            _maxMines = 9
        }
        
        _openedTiles = 0
        _flaggedMine = 0
        _flaggedTiles = 0
        
        score = 0
        
        _minesAmount = 0
        
        _mineTilesList.removeAll()
        _tilesList.removeAll()
        
        gameState = .playing
//        flaggedTilesChanged?(_flaggedTiles)
        
        print("Max mine", _maxMines)
    }
    
    //MARK: Prepare data
    func setupTileField() {
        resetTilesList()
        
        generateMine(maxMine: _maxMines)
        
        if _mineTilesList.count > 0 {
            for mineTile in _mineTilesList {
                countMinesAround(tile: mineTile)
            }
        }
        flaggedTilesChanged?(_flaggedTiles)
    }
    
    private func resetTilesList() {
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
    
    // Repeat setting mine for tile until _mineAmount = _maxMine
    func generateMine(maxMine: Int) {
        repeat {
            let x = arc4random_uniform(UInt32(_cols))
            let y = arc4random_uniform(UInt32(_rows))
            if let selectedTile = getTileAt(Int(x), Int(y)) {
                if !selectedTile.tileModel.isMine {
                    selectedTile.setMine()
                    if selectedTile.tileModel.isMine {
                        _minesAmount += 1
                        _mineTilesList.append(selectedTile)
                    }
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
    
    // Get nearby tiles of given tile, ignore postition outside board
    func getNearbyTiles(of: TileControl) -> [TileControl] {
        var nearbyTiles: [TileControl] = []
        
        for (rowOffset, colOffset) in _nearbyTileOffset {
            if let nearbyTile = getTileAt(of.tileModel.x + rowOffset, of.tileModel.y + colOffset) {
                if (nearbyTile.isEnabled) {
                    nearbyTiles.append(nearbyTile)
                }
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

    /*
     This function is too big
     Trigger when player touch a tile
     If win condition is pass: stop the game and call win
     If current touch mode:
     - flag: ignore if number of flagged tile number is equal current mines number
             if current tile is hidden -> flagged -> marked -> hidden
    */
    func touch(_ tile: TileControl) {
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
                // Expand if no mine around
                if tile.tileModel.mineCounter > 0 {
                    return
                }
                
                let nearbyTiles = getNearbyTiles(of: tile)
                
                for nearbyTile in nearbyTiles {
                    // Countinue expand if nearby tile is touchable and has no mine around it
                    if nearbyTile.tileModel.mineCounter == 0 {
                        nearbyTile.openTile()
                        touch(nearbyTile)
                    }
                    else {
                        nearbyTile.openTile()
                    }
                }
            }
        }
        if isWin(){
            win()
        }
    }
    
    // Win if flagged tiles > 0 (aka: User doesn't mass flag every tile on the board) and:
    // - User open every "not mine" tiles
    // Or: - user flagged every mine tiles
    func isWin() -> Bool{
        var flag = false
        if _rows * _cols - _openedTiles == _minesAmount {
            flag = true
        }
        return flag
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
