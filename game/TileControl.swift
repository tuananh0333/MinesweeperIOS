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
    private var _tileSize: CGFloat = CGFloat(5)
    private var _tileModel: Tile = Tile()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateImage()
    }
    
    func updateImage() {
        guard let imageName = _tileModel.imageName else {
            print("Image is not defined")
            return
        }
        
        if let image = UIImage(named: imageName) {
            if self._tileModel.state == .flagged || self._tileModel.state == .marked {
                self.setBackgroundImage(UIImage(named: "hidden"), for: .normal)
                self.setImage(image, for: .normal)
            }
            else {
                self.setBackgroundImage(image, for: .normal)
                self.setImage(UIImage(named: "emptyImage"), for: .normal)
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
        return self._tileModel
    }
    
    func setTileModel(_ tileModel: Tile) {
        self._tileModel = tileModel
    }
    
    func touchTile(touchMode: BoardModel.TouchMode) {
        _tileModel.touch(touchMode: touchMode)
        
        updateImage()
        
        if _tileModel.state == .opened && !_tileModel.isOpened {
            BoardModel.shareInstance.score += _tileModel.mineCounter * 2
            _tileModel.isOpened = true
            isEnabled = false
        }
    }

    // Tile button is touchable if:
    // - game is not win or over
    // - state of tile is hide (or untouched)
    func isTouchable() -> Bool {
        if _tileModel.state == .hide {
            return true
        }
        
        return false
    }
    
    func setMine(chance: Float) {
        if _tileModel.isMine {
            return
        }
        
        if arc4random_uniform(UInt32(chance)) == 0 {
            _tileModel.isMine = true
            _tileModel.state = .hide
            updateImage()
        }
    }
    
    func end() {
        guard var imageName = _tileModel.imageName else {
            print("Image is not defined")
            return
        }
        
        if _tileModel.isMine && _tileModel.state != .exploded {
            print(_tileModel.state)
            if _tileModel.state == .flagged {
                imageName.append("bomb")
                print(imageName)
            }
            else {
                imageName = "unflaggedbomb"
            }
        }
        
        if let image = UIImage(named: imageName) {
            self.setImage(image, for: .normal)
        }
        else {
            print("Image is not found")
            return
        }
    }
}
