//
//  RatingController.swift
//  FoodManagement
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

@IBDesignable class RowStackController: UIStackView {
    //MARK: Properties
    private var tilesList = [TileControl]()
    
    //MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTile()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupTile()
    }
    
    //MARK: Init
    func setupTile() {
        for tile in tilesList {
            removeArrangedSubview(tile)
            tile.removeFromSuperview()
        }
        
        tilesList.removeAll()
        
        self.distribution = .fillEqually
        self.spacing = 3
    }
    
    
    func addTile(_ tile: TileControl){
        //add buttons to stack view
        addArrangedSubview(tile)
        
        //add the button to list
        tilesList += [tile]
    }
}
