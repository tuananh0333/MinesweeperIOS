//
//  RatingController.swift
//  FoodManagement
//
//  Created by le tuan anh on 5/11/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

@IBDesignable class ColumnStackController: UIStackView {
    //MARK: Properties
    private var listStackViews = [RowStackController]()
    @IBInspectable let rows: Int = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        for StackView in listStackViews {
            removeArrangedSubview(StackView)
            StackView.removeFromSuperview()
        }
        listStackViews.removeAll()
        for x in 0..<rows {
            // Create new button
            let stkRow = RowStackController()
            stkRow.setIndex(index: x)
            
            let bundle = Bundle(for: type(of: self))
            
            //config width and height attributes
            stkRow.translatesAutoresizingMaskIntoConstraints = false
            //add buttons to stack view
            addArrangedSubview(stkRow)
            //add the button to list
            listStackViews += [stkRow]
        }
    }
}
