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
    private var rowList = [RowStackController]()

    private let board: BoardModel = BoardModel.shareInstance
    private var rows: Int = 16
    private var cols: Int = 8
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setBoardSize(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        board.setBoardSize(rows: rows, cols: cols)
        
        setupButton() 
    }
    
    func setupButton() {
        resetRowList()
        
        for y in 0 ..< rows {
            //MARK: Create new row stack
            let stkRow = RowStackController()

            for x in 0 ..< cols {
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
            
            print(pressedButton.getTileModel().getX(), ",", pressedButton.getTileModel().getY(), "")
            print("Mine around: ", pressedButton.getTileModel().getMineCounter())
        }
    }
}
