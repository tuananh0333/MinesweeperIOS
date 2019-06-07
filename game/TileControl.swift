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
    
    var tileModel: Tile {
        set { _tileModel = newValue }
        get { return _tileModel }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateImage()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage() {
        guard let imageName = _tileModel.imageName else {
            print("Image is not defined")
            return
        }
        
        if let image = UIImage(named: imageName) {
            self.setBackgroundImage(image, for: .normal)
        }
        else {
            print("Image is not found")
            return
        }
    }
    
    func flagTile() {
        _tileModel.flagTile()
        updateImage()
        
        if BoardModel.shareInstance.isWin() {
            BoardModel.shareInstance.win()
        }
    }
    
    // Return false if open a mine tile
    func openTile() {
        _tileModel.openTile()
        
        if (_tileModel.isMine) {
            updateImage()
            return
        }
        
        if isEnabled {
            BoardModel.shareInstance.score += _tileModel.mineCounter * 2
            BoardModel.shareInstance.openedTiles += 1
            isEnabled = false
        }
        
        updateImage()
        
        if BoardModel.shareInstance.isWin() {
            BoardModel.shareInstance.win()
        }
        
    }
    
    func setMine(chance: Float) {
        if _tileModel.isMine {
            return
        }
        
        if arc4random_uniform(UInt32(chance)) == 0 {
            _tileModel.isMine = true
            _tileModel.state = .marked
            updateImage()
            print("Mine: ", _tileModel.pos)
        }
    }
    
    func setMine() {
        _tileModel.isMine = true
        _tileModel.state = .hide
        updateImage()
        print("Mine: ", _tileModel.pos)
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
            }
            else {
                imageName = "unflaggedbomb"
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
    
    func increaseAffectedTilesMineCounter(tilesList: inout [TileControl]) {
        for tile in tilesList {
            tile.tileModel.increaseMineCounter(by: 1)
        }
    }
}
