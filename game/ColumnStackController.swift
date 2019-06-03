//
//  RatingController.swift
//  FoodManagement
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

@IBDesignable class ColumnStackController: UIStackView {
    enum TouchMode {
        case flag
        case normal
    }
    
    //MARK: Properties
    private var rowList = [RowStackController]()
    @IBInspectable let rows: Int = 16
    @IBInspectable let cols: Int = 8
    var currentMine = 0
    var maxMine = 10
    var openedTiles = 0
    var touchMode: TouchMode = .normal
    var tilesField: [[Tile]] = []
    var isOver: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTileField()
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupTileField()
        setupButton()
    }
    
    func setupButton() {
        for row in rowList {
            removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rowList.removeAll()
        
        for x in 0..<rows {
            // Create new button
            let stkRow = RowStackController()
            stkRow.setIndex(index: x)
            
            for y in 0..<cols {
                // Create new button
                let btnTile = TileControl()
                btnTile.createTile(x: x, y: y, tileSize: CGFloat(5))
                btnTile.tileModel = tilesField[x][y]
                
                //config width and height attributes
                btnTile.translatesAutoresizingMaskIntoConstraints = false
                
                btnTile.addTarget(self, action: #selector(ColumnStackController.tilePressed(button:)), for: .touchUpInside)
                
                stkRow.addTileToStackView(tile: btnTile)
            }
            
            //config width and height attributes
            stkRow.translatesAutoresizingMaskIntoConstraints = false
            //add buttons to stack view
            addArrangedSubview(stkRow)
            //add the button to list
            rowList += [stkRow]
        }
    }
    
    func setupTileField() {
        currentMine = 0
        isOver = false
        tilesField = []
        for row in 0 ..< rows {
            tilesField.append([])
            for col in 0 ..< cols {
                tilesField[row].append(Tile(x: row, y: col))
            }
        }
        
        while (currentMine < maxMine) {
            for row in 0 ..< rows {
                for col in 0 ..< cols {
                    if currentMine < maxMine {
                        setMineForTile(tile: tilesField[row][col])
                    }
                }
            }
        }
    }
    
    func setMineForTile(tile: Tile) {
        if tile.isMine {
            return
        }
        
        if (arc4random() % UInt32(maxMine)) == 0 {
            tile.isMine = true
            tile.status = .flagged
            currentMine += 1
            print(tile.x, ",", tile.y, "")
            increaseNearbyTileCounter(tile: tile)
        }
    }
    
    func increaseNearbyTileCounter(tile: Tile) {
        let nearbyTiles = getNearbyTiles(of: tile)
        for nearbyTile in nearbyTiles {
            if (!nearbyTile.isMine) {
                nearbyTile.mineCounter += 1
            }
        }
    }
    
    func getNearbyTiles(of: Tile) -> [Tile] {
        var nearbyTiles: [Tile] = []
        
        let offsets = [(-1, -1), (0, -1) , (1, -1),
                       (-1, 0), (1, 0),
                       (-1, 1), (0, 1), (1, 1)]
        
        for (rowOffset, colOffset) in offsets {
            if let nearbyTile = getTileAt(of.x + rowOffset, of.y	 + colOffset) {
                nearbyTiles.append(nearbyTile)
                print(nearbyTile.x, ",", nearbyTile.y)
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

    
    //MARK: Rating actions
    @objc func tilePressed(button: UIButton) {
        if let pressedButton = button as? TileControl {
            if !pressedButton.pressed(touchMode: .normal) {
                isOver = true
                print("Game is over")
                setupTileField()
                setupButton()
                return
            }
            print(pressedButton.getCol(), ",", pressedButton.getRow(), "")
            print("Mine around: ", pressedButton.tileModel.mineCounter)
        }
    }
}
