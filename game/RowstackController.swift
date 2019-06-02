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
    
    var index: Int?
    
//    init(index: Int) {
//
//        self.index = index
//    }
    func setIndex(index:Int) {
        self.index = index
        setupButton()
    }
    
    private var listButtons = [UIButton]()
    @IBInspectable var buttons: Int = 9 {
        didSet{
            changeButtonsState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
//        setupButton()
    }
    
    func setupButton() {
        for Button in listButtons {
            removeArrangedSubview(Button)
            Button.removeFromSuperview()
        }
        listButtons.removeAll()
        for y in 0..<buttons {
            // Create new button
            let newTile = Tile(x: self.index!, y: y)
            let btnBomb = TileControl()
            btnBomb.createTile(tileModel: newTile, tileSize: CGFloat(5))
            
            let bundle = Bundle(for: type(of: self))
            
            if let imgBombNomal = UIImage(named: "unflagedbomb", in: bundle, compatibleWith: self.traitCollection) {
                btnBomb.setImage(imgBombNomal, for: .normal)
            }
            
            //config width and height attributes
            btnBomb.translatesAutoresizingMaskIntoConstraints = false
            btnBomb.addTarget(self, action: #selector(RowStackController.tilePressed(button:)), for: .touchUpInside)
            //add buttons to stack view
            addArrangedSubview(btnBomb)
            //add the button to list
            listButtons += [btnBomb]
        }
        self.distribution = .fillEqually
        changeButtonsState()
    }
    
    //MARK: Rating actions
    @objc func tilePressed(button: UIButton) {
//        if let index = listButtons.index(of: button){
////            let currentRating = index+1
////            if rating == currentRating {
////                rating -= 1
////            } else {
////                rating = currentRating
////            }
//        }
//        for i in 0..<rating {
//            listButtons[i].isSelected = true
//        }
//        if(rating < starCount) {
//            for i in rating...starCount-1 {
//                listButtons[i].isSelected = false
//            }
//        }
        if let cusbut = button as? TileControl {
            print(cusbut.getCol(), ",", cusbut.getRow(), "")
//            print("Star button is pressed")
        }
    }
    
    func changeButtonsState() {
        //set isSelected for each button
        for(index, button) in listButtons.enumerated() {
//            button.isSelected = index < rating
        }
    }
}
