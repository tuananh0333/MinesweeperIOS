//
//  TileControl.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import UIKit

class TileControl: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var tileSize: CGFloat = CGFloat(5)
    var tileModel: Tile
    
    func createTile(tileModel: Tile, tileSize: CGFloat) {
        self.tileModel = tileModel
        self.tileSize = tileSize

        let x = CGFloat(self.tileModel.x) * tileSize
        let y = CGFloat(self.tileModel.y) * tileSize

        let tileFrame = CGRect(x: x, y: y, width: tileSize, height: tileSize)
//        super.init(
    }
    
    override init(frame: CGRect) {
        self.tileModel = Tile()
        
        
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        tileModel = Tile()
        fatalError("init(coder:) has not been implemented")
    }
    
//    init(tile: Tile) {
//        super.init()
//        self.tileModel = tile
//    }
    
    func getButtonImage() {
        var btnImage: UIImage?
        
        let bundle = Bundle(for: type(of: self))
        
        switch self.tileModel.status {
        case .flag:
            if let imgFlag = UIImage(named: "flagged",
                                     in: bundle,
                                     compatibleWith: self.traitCollection) {
                btnImage = imgFlag
            }
        case.mark:
            if let imgMark = UIImage(named: "????",
                                     in: bundle,
                                     compatibleWith: self.traitCollection) {
                btnImage = imgMark
            }
        case.opened:
            if let imgMine = UIImage(named: "????",
                                     in: bundle,
                                     compatibleWith: self.traitCollection) {
                btnImage = imgMine
            }
        default:
            if let imgHide = UIImage(named: "????",
                                     in: bundle,
                                     compatibleWith: self.traitCollection) {
                btnImage = imgHide
            }
        }
        
        setBackgroundImage(btnImage, for: .normal)
    }
    
    func isMine() -> Bool {
        return tileModel.isMine
    }
    
    func setMine(_ isMine: Bool) {
        tileModel.isMine = isMine
    }
    
    func increaseCounter() {
        tileModel.mineCounter += 1
    }
    
    func decreaseCounter() {
        tileModel.mineCounter -= 1
    }
    
    func getStatus() -> Tile.Status {
        return tileModel.status
    }
    
    func setStatus(status: Tile.Status) {
        tileModel.status = status
    }
    
    func getRow() -> Int {
        return tileModel.y
    }
    
    func getCol() -> Int {
        return tileModel.x
    }
}
