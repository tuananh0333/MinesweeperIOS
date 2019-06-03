//
//  TileControl.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import UIKit

class TileControl: UIButton {

    var tileSize: CGFloat = CGFloat(5)
    var tileModel: Tile {
        didSet {
            setImage()
        }
    }
    
    func createTile(x:Int, y:Int, tileSize: CGFloat) {
        self.tileModel = Tile(x: x, y: y)
        self.tileSize = tileSize

        setImage()
    }
    
    func setImage() {
        let bundle = Bundle(for: type(of: self))

        if let image = UIImage(named: tileModel.imageDictionary[tileModel.status]!, in: bundle, compatibleWith: self.traitCollection) {
            setBackgroundImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        self.tileModel = Tile()
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        print(status)
        tileModel.status = status
        setImage()
    }
    
    func getRow() -> Int {
        return tileModel.y
    }
    
    func getCol() -> Int {
        return tileModel.x
    }
    
    func pressed(touchMode: ColumnStackController.TouchMode) -> Bool{
        var isOk = true
        if touchMode == .normal {
            if getStatus() == .hide || getStatus() == .flagged {
                if (isMine()) {
                    setStatus(status: .exploded)
                    isOk = false
                }
                else {
                    setStatus(status: .opened)
                }
            }
        }
        else {
            //MARK: Touchtype == Flag
            switch getStatus() {
            case .hide:
                setStatus(status: .flagged)
            case .flagged:
                setStatus(status: .marked)
            case .marked:
                setStatus(status: .hide)
            case .opened:
                break
            case .flagging:
                break
            case .exploded:
                break
            }
        }
        return isOk
    }
}
