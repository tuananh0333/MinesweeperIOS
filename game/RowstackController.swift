//
//  RatingController.swift
//  FoodManagement
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

@IBDesignable class RowStackController: UIStackView {
    //MARK: Fields
    var index: Int? {
        didSet {
            setupButton()
        }
    }
    private var tilesRow = [TileControl]()
    var buttons: Int = 9
    
    //MARK: Properties
    func setIndex(index:Int) {
        self.index = index
    }
    
    //MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Init
    func setupButton() {
        for tile in tilesRow {
            removeArrangedSubview(tile)
            tile.removeFromSuperview()
        }
        
        tilesRow.removeAll()
        
        self.distribution = .fillEqually
        self.spacing = 1
    }
    
    
    func addTileToStackView(tile: TileControl){
        //add buttons to stack view
        addArrangedSubview(tile)
        
        //add the button to list
        tilesRow += [tile]
    }
}
