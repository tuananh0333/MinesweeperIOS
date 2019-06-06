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
    private var tileModel: Tile {
        didSet {
            setImage()
        }
    }
    
    func createTile(x:Int, y:Int, tileSize: CGFloat) {
        self.tileModel = Tile(x, y)
        self.tileSize = tileSize

        setImage()
    }
    
    func setImage() {
        let bundle = Bundle(for: type(of: self))
        if let image = UIImage(named: tileModel.getImageName()!, in: bundle, compatibleWith: self.traitCollection) {
            if(tileModel.getState() == .flagged || tileModel.getState() == .flagging) {
                setImage(image, for: .normal)
                setBackgroundImage(UIImage(named: "hidden", in: bundle, compatibleWith: self.traitCollection), for: .normal)
            } else {
                if let imageName = tileModel.getImageName() {
                    if let image = UIImage(named: imageName, in: bundle, compatibleWith: self.traitCollection) {
                        setBackgroundImage(image, for: .normal)
//                        setImage(image, for: .normal)
                    }
                }
            }
            updateImage()
        }
    }
    
    //MARK: Constructor
    override init(frame: CGRect) {
        self.tileModel = Tile()
        
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage() {
        let bundle = Bundle(for: type(of: self))
        if let imageName = tileModel.getImageName() {
            if let image = UIImage(named: imageName,
                                   in: bundle,
                                   compatibleWith: self.traitCollection) {
                setBackgroundImage(image, for: .normal)
            }
            else {
                print ("Can't not find image!")
            }
        }
        else {
            print ("Image name for state: ", tileModel.getState(), " is not define!")
        }
    }
    
    func getTileModel() -> Tile {
        return self.tileModel
    }
    
    func setTileModel(_ tileModel: Tile) {
        self.tileModel = tileModel
    }
    
    func touch(touchMode: GameModel.TouchMode) -> Tile.State {
        let state = tileModel.touch(touchMode: touchMode)
        updateImage()
        return state
    }
}
