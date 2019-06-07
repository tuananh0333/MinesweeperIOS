//
//  RatingController.swift
//  FoodManagement
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ColumnStackController: UIStackView {
    //MARK: Properties
    private var rowList = [RowStackController]() //Array(repeating: RowStackController, count: board.rows)

    private let board: BoardModel = BoardModel.shareInstance
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
    }
    
    func setupButton() {
        resetRowList()
        
        for y in 0 ..< board.rows {
            //MARK: Create new row stack
            let stkRow = RowStackController()

            for x in 0 ..< board.cols {
                //MARK: Create new button at x, y
                if let btnTile = board.getTileAt(x, y) {
                    
                    //config width and height attributes
                    btnTile.translatesAutoresizingMaskIntoConstraints = false
                    
                    btnTile.addTarget(self, action: #selector(touchTile(button:)), for: .touchUpInside)
                    
                    stkRow.addTile(btnTile)
                }
                else {
                    print("Data is not completely init at!", x, ", ", y)
                }
            }
            
            //config width and height attributes
            stkRow.translatesAutoresizingMaskIntoConstraints = false
            
            //add new row to colStack
            addArrangedSubview(stkRow)
            rowList += [stkRow]
        }
    }
    
    func resetRowList() {
        for row in rowList {
            removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rowList.removeAll()
    }
    
    //MARK: Rating actions
    @objc func touchTile(button: UIButton) {
        if let pressedButton = button as? TileControl {
            if board.gameState != .playing {
                return
            }
            
            board.touch(pressedButton)
        }
    }
}
