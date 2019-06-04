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
    private var board: BoardModel = BoardModel()
    @IBInspectable var rows: Int = 16 {
        didSet {
            initData()
        }
    }
    @IBInspectable var cols: Int = 8 {
        didSet {
            initData()
        }
    }
    
    //MARK: Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initData()
    }
    
    func toggleFlag() {
        board.toggleFlag()
    }
    
    func initData() {
        board = BoardModel(rows, cols)
        setupButton()
    }
    
    func setupButton() {
        for row in rowList {
            removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        rowList.removeAll()
        
        for y in 0 ..< rows {
            // Create new button
            let stkRow = RowStackController()

            for x in 0 ..< cols {
                // Create new button
                
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
            
            print(pressedButton.getTileModel().getY(), ",", pressedButton.getTileModel().getX(), "")
            print("Mine around: ", pressedButton.getTileModel().getMineCounter())
        }
    }
}
