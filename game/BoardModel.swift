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
    //MARKS: Fields
    private var touchMode: TouchMode = .normal
    private var rows: Int = 16
    private var cols: Int = 8
    private var currentMine = 0
    private var maxMine = 0
    private var openedTiles = 0
    private var flaggedTiles = 0
    private var tilesField: [[TileControl]] = []
    var isOver: Bool = false
    
    //MARK: Constructor
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols
        
        createBoard()
    }
    
    init() {
        createBoard()
    }
    
    func createBoard() {
        currentMine = 0
        isOver = false
        tilesField = []
        for x in 0 ..< cols {
            tilesField.append([])
            for y in 0 ..< rows {
                let btnTile = TileControl()
                btnTile.setTileModel(Tile(x: x, y: y))
                tilesField[x].append(btnTile)
            }
        }
        
        setupTileField(maxMine: 0)
    }
    
    //MARK: Prepare data
    func setupTileField(maxMine: Int = 0) {
        self.maxMine = maxMine

        repeat {
            for x in 0 ..< cols {
                for y in 0 ..< rows {
                    setMineForTile(tile: tilesField[x][y])
                }
            }
        } while (currentMine < maxMine)
        
        for x in 0 ..< cols {
            for y in 0 ..< rows {
                countMineAround(tile: tilesField[x][y])
            }
        }
    }

    func setMineForTile(tile: TileControl) {
        let tileModel = tile.getTileModel()
        if tileModel.isMineTile() {
            return
        }
        
        var percent: Bool = false
        
        if self.maxMine != 0 {
            percent = ((arc4random() % UInt32(maxMine)) == 0)
        }
        else {
            percent = (arc4random_uniform(10) == 0)
        }
        
//        let percent: Bool = self.maxMine != 0 ? (arc4random() % UInt32(maxMine)) == 0 ? : percent = arc4random_uniform(3) == 0
        
        if percent == true {
            tileModel.setMine(true)
//            tileModel.setState(.flagged)
            currentMine += 1
            print("Mine: ",tileModel.getX(), ",", tileModel.getY(), "")
        }
        
        tile.setTileModel(tileModel)
    }
    
    func countMineAround(tile: TileControl) {
        let nearbyTiles = getNearbyTiles(of: tile)
        for nearbyTile in nearbyTiles {
            let tileModel = nearbyTile.getTileModel()
            if (tileModel.isMineTile()) {
                tile.getTileModel().increaseMineCounter(by: 1)
            }
            
        }
    }
    
    func getNearbyTiles(of: TileControl) -> [TileControl] {
        var nearbyTiles: [TileControl] = []
        
        let offsets = [(-1, -1), (0, -1) , (1, -1),
                       (-1, 0), (1, 0),
                       (-1, 1), (0, 1), (1, 1)]
        
        for (rowOffset, colOffset) in offsets {
            if let nearbyTile = getTileAt(of.getTileModel().getX() + rowOffset, of.getTileModel().getY() + colOffset) {
                nearbyTiles.append(nearbyTile)
            }
        }
        
        return nearbyTiles
    }
    
    func getTileAt(_ x: Int, _ y: Int) -> TileControl? {
        if (x >= 0 && x < self.cols
            && y >= 0 && y < self.rows) {
            return tilesField[x][y]
        }
        else {
            return nil
        }
    }

    func touch(_ tile: TileControl){
        if touchMode == .flag && flaggedTiles == currentMine {
            print("You have reach maximum flagged")
            return
        }

        if isWin() {
            print("You win")
            return
        }
        
        let state = tile.getTileModel().touch(touchMode: touchMode)
        tile.updateImage()
        print(state)
        
        switch state {
        case .opened:
            if tile.getTileModel().getMineCounter() < 2 {
                
                let nearbyTiles = getNearbyTiles(of: tile)
                
                for nearbyTile in nearbyTiles {
                    let tileModel = nearbyTile.getTileModel()
                    if (!tileModel.isMineTile() && tileModel.getState() == .hide ) {
                        touch(nearbyTile)
                    }
                }
            }
            openedTiles += 1
        case .exploded:
            isOver = true
        case .flagged:
            fallthrough
        case .marked:
            flaggedTiles += 1
        default:
            break;
        }
    }
    
    func isWin() -> Bool{
        print(currentMine)
        
        var flaggedMine: Int = 0
        
        if rows * cols - openedTiles == currentMine {
            return true
        }

        if flaggedTiles == currentMine {
            for x in 0 ..< cols {
                for y in 0 ..< rows {
                    let currentTile = tilesField[x][y]
                    if currentTile.getTileModel().isMineTile() {
                        if currentTile.getTileModel().getState() == .flagged {
                            flaggedMine += 1
                        }
                    }
                }
            }
            
            if flaggedMine == currentMine {
                return true
            }
        }
        
        return false
    }
    
    func toggleFlag() {
        if touchMode == .normal {
            touchMode = .flag
        }
        else {
            touchMode = .normal
        }
    }
}
