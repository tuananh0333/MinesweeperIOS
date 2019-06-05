//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    public var isOver = false {
        didSet {
            if(isOver) {
                let alert = UIAlertController(title: "Game Over", message: "Back to home?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancle", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public var score:Int = 0{
        didSet {
            lblScore.text = String(score)
        }
    }
    
    public var flags: Int = 0 {
        didSet {
            lblBombNumber.text = String(flags)
        }
    }
    
    
    var isFlagging = false {
        didSet {
            if isFlagging {
                btnFlagOutlet.setBackgroundImage(UIImage(named: "flagged"), for: .normal)
            } else {
                btnFlagOutlet.setBackgroundImage(UIImage(named: "flagging"), for: .normal)
            }
            
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
        let alert = UIAlertController(title: "Back to home", message: "Back to home will stop your current game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnFlag(_ sender: UIButton) {
        isFlagging = !isFlagging
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

