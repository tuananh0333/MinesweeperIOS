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
    private var board: BoardModel = BoardModel() {
        didSet {
            setupButton()
        }
    }
    private var rows: Int = 16
    private var cols: Int = 8
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func toggleFlag() {
        board.toggleFlag()
    }
    
    func setBoardSize(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        initData()
    }
    
    func initData() {
        //MARK: Make new board model and generate data
        board = BoardModel(rows, cols)
    }
    
    func setupButton() {
        //MARK: Fresh row list
        for row in rowList {
            removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rowList.removeAll()
        
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
    
    //MARK: Rating actions
    @objc func touchTile(button: UIButton) {
        if board.isOver {
            //MARK: Show replay dialog
            return
        }
        
        if let pressedButton = button as? TileControl {
            board.touch(pressedButton)
            
            print(pressedButton.getTileModel().getX(), ",", pressedButton.getTileModel().getY(), "")
            print("Mine around: ", pressedButton.getTileModel().getMineCounter())
        }
    }
}
