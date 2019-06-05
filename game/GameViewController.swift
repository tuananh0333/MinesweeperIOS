//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isFlagging = false {
        didSet {
//            if isFlagging {
//                btnFlagOutlet.setBackgroundImage(UIImage(named: "flagged"), for: .normal)
//            } else {
//                btnFlagOutlet.setBackgroundImage(UIImage(named: "flagging"), for: .normal)
//            }
            
            stkBoard.toggleFlag()
        }
    }
	
    @IBOutlet weak var stkBoard: ColumnStackController!
    @IBOutlet weak var lblBombNumber: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnFlagOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Create board
        stkBoard.setBoardSize(rows: 16, cols: 8)
    }

    
    @IBAction func btnReset(_ sender: UIButton) {
        stkBoard.initData()
    }
    
    @IBAction func btnBackToHome(_ sender: UIButton) {
    }

    @IBAction func btnFlag(_ sender: UIButton) {
        isFlagging = !isFlagging
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

