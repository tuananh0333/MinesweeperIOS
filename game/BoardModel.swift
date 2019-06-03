//
//  BoardModel.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/3/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import Foundation
class BoardModel {
    let rows: Int = 16
    let cols: Int = 8
    var currentMine = 0
    var maxMine = 10
    var openedTiles = 0
    var tilesField: [[Tile]] = []
    var isOver: Bool = false
    
    init() {
        currentMine = 0
        isOver = false
        tilesField = []
        for row in 0 ..< rows {
            tilesField.append([])
            for col in 0 ..< cols {
                tilesField[row].append(Tile(x: row, y: col))
            }
        }
    }
    
    func setupTileField(maxMine: Int = 0) {
        self.maxMine = maxMine

        repeat {
            for row in 0 ..< rows {
                for col in 0 ..< cols {
                    setMineForTile(tile: tilesField[row][col])
                }
            }
        } while (currentMine < maxMine)
    }

    func setMineForTile(tile: Tile) {
        if tile.isMineTile() {
            return
        }
        
        var percent: Bool = false
        
        if self.maxMine != 0 {
            percent = (arc4random() % UInt32(maxMine)) == 0
        }
        else {
            percent = arc4random_uniform(3) == 0
        }
        
        if percent {
            tile.setMine(true)
            currentMine += 1
            print(tile.getX(), ",", tile.getY(), "")
            increaseNearbyTileCounter(tile: tile)
        }
    }
    
    func increaseNearbyTileCounter(tile: Tile) {
        let nearbyTiles = getNearbyTiles(of: tile)
        for nearbyTile in nearbyTiles {
            if (!nearbyTile.isMineTile()) {
                nearbyTile.setMineCounter(value: nearbyTile.getMineCounter() + 1)
            }
        }
    }
    
    func getNearbyTiles(of: Tile) -> [Tile] {
        var nearbyTiles: [Tile] = []
        
        let offsets = [(-1, -1), (0, -1) , (1, -1),
                       (-1, 0), (1, 0),
                       (-1, 1), (0, 1), (1, 1)]
        
        for (rowOffset, colOffset) in offsets {
            if let nearbyTile = getTileAt(of.getX() + rowOffset, of.getY() + colOffset) {
                nearbyTiles.append(nearbyTile)
            }
        }
        
        return nearbyTiles
    }
    
    func getTileAt(_ row: Int, _ col: Int) -> Tile? {
        if (row >= 0 && row < self.rows
            && col >= 0 && col < self.cols) {
            return tilesField[row][col]
        }
        else {
            return nil
        }
    }

    func touched(_ tile: Tile, touchMode: ColumnStackController.TouchMode) {
        if tile.getMineCounter() == 0 {
            let nearbyTiles = getNearbyTiles(of: tile)
            for nearbyTile in nearbyTiles {
                if (!nearbyTile.isMineTile()) {
                    touched(nearbyTile, touchMode: touchMode)
                }
            }
        }
        tile.pressed(touchMode: touchMode)
    }
}
