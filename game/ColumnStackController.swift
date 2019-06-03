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
    
    var touchMode: TouchMode = .normal
    
    private var board = BoardModel()
    
    //MARK: Properties
    private var rowList = [RowStackController]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        board.setupTileField()
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        board.setupTileField()
        setupButton()
    }
    
    func setupButton() {
        for row in rowList {
            removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rowList.removeAll()
        
        for x in 0..<board.rows {
            // Create new button
            let stkRow = RowStackController()
            stkRow.setIndex(index: x)
            
            for y in 0..<board.cols {
                // Create new button
                let btnTile = TileControl()
                btnTile.createTile(x: x, y: y, tileSize: CGFloat(5))
                btnTile.setTileModel(board.tilesField[x][y])
                
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
    
    
    
    //MARK: Rating actions
    @objc func tilePressed(button: UIButton) {
        if let pressedButton = button as? TileControl {
            if !pressedButton.pressed(touchMode: .normal) {
                board.isOver = true
                print("Game is over")
                board = BoardModel()
                board.setupTileField()
                setupButton()
                return
            }
            print(pressedButton.getTileModel().getY(), ",", pressedButton.getTileModel().getX(), "")
            print("Mine around: ", pressedButton.getTileModel().getMineCounter())
        }
    }
}
