//
//  TileControl.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import UIKit

class TileControl: UIButton {
    //MARK: Properties
    private var tileSize: CGFloat = CGFloat(5)
    private var tileModel: Tile = Tile()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage()
    }
    
    func setImage() {
        guard let imageName = tileModel.getImageName() else {
            print("Image is not defined")
            return
        }
        
        if let image = UIImage(named: imageName) {
            setBackgroundImage(image, for: .normal)
        }
        else {
            print("Image is not found")
            return
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTileModel() -> Tile {
        return self.tileModel
    }
    
    func setTileModel(_ tileModel: Tile) {
        self.tileModel = tileModel
    }
    
    func touchTile(touchMode: BoardModel.TouchMode) {
        tileModel.touch(touchMode: touchMode)
        setImage()
        
        if tileModel.getState() == .opened && !tileModel.isOpened {
            BoardModel.shareInstance.score += tileModel.getMineCounter() * 2
            tileModel.isOpened = true
        }
    }

    // Tile button is touchable if:
    // - game is not win or over
    // - state of tile is hide (or untouched)
    func isTouchable() -> Bool {
        if tileModel.getState() == .hide {
            return true
        }
        
        return false
    }
    
    func setMine(chance: Float) {
        if tileModel.isMineTile() {
            return
        }
        
        if arc4random_uniform(UInt32(chance)) == 0 {
            tileModel.setMine(true)
            tileModel.setState(.marked)
            setImage()
            print("Mine: ", tileModel.getPos())
        }
    }
    
    func end() {
        guard var imageName = tileModel.getImageName() else {
            print("Image is not defined")
            return
        }
        
        if tileModel.isMineTile() {
            if tileModel.getState() == .flagged {
                imageName.append("ended")
            }
        }
        
        if let image = UIImage(named: imageName) {
            setBackgroundImage(image, for: .normal)
        }
        else {
            print("Image is not found")
            return
        }
    }
}
