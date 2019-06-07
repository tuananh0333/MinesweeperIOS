//
//  RowStackController.swift
//  Minesweeper
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class RowStackController: UIStackView {
    //MARK: Properties
    private var tilesList = [TileControl]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createEmptyStackView()
        configAttributes()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        createEmptyStackView()
        configAttributes()
    }
    
    //MARK: Remove all Tile in list, then config
    func createEmptyStackView() {
        for tile in tilesList {
            removeArrangedSubview(tile)
            tile.removeFromSuperview()
        }
        
        tilesList.removeAll()
    }
    
    private func configAttributes() {
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
