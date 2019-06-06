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
        
        updateImage()
    }
    
    func updateImage() {
        guard let imageName = tileModel.getImageName() else {
            print("Image is not defined")
            return
        }
        
        if let image = UIImage(named: imageName) {
            if self.tileModel.getState() == .flagged || self.tileModel.getState() == .marked {
                setBackgroundImage(UIImage(named: "hidden"), for: .normal)
                setImage(image, for: .normal)
            }
            else {
                setBackgroundImage(image, for: .normal)
                setImage(UIImage(named: "emptyImage"), for: .normal)
            }
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
        updateImage()
        
        if tileModel.getState() == .opened && !tileModel.isOpened {
            BoardModel.shareInstance.score += tileModel.getMineCounter() * 2
            tileModel.isOpened = true
            isEnabled = false
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
            tileModel.setState(.hide)
            updateImage()
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
                imageName.append("bomb")
                print(imageName)
            }
        }
        
        if let image = UIImage(named: imageName) {
            self.setBackgroundImage(image, for: .normal)
            self.setImage(image, for: .normal)
        }
        else {
            print("Image is not found")
            return
        }
    }
}
