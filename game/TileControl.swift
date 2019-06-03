//
//  TileControl.swift
//  Minesweeper
//
//  Created by CNTT-MAC on 6/2/19.
//  Copyright © 2019 CNTT-MAC. All rights reserved.
//

import UIKit

class TileControl: UIButton {

    private var tileSize: CGFloat = CGFloat(5)
    private var tileModel: Tile {
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
            if(tileModel.status == .flagged || tileModel.status == .flagging) {
                setImage(image, for: .normal)
                setBackgroundImage(UIImage(named: "hiden", in: bundle, compatibleWith: self.traitCollection), for: .normal)
            } else {
        if let imageName = tileModel.getImageName() {
            if let image = UIImage(named: imageName, in: bundle, compatibleWith: self.traitCollection) {
                setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        self.tileModel = Tile()
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTileModel() -> Tile {
        return self.tileModel
    }
    
    func setTileModel(_ tileModel: Tile) {
        self.tileModel = tileModel
    }
    
    func pressed(touchMode: ColumnStackController.TouchMode) -> Bool{
        return tileModel.pressed(touchMode: touchMode)
    }
}
