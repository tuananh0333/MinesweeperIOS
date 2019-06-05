//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        }
    }
	
    @IBOutlet weak var lblBombNumber: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnFlagOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnBackToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFlag(_ sender: UIButton) {
        isFlagging = !isFlagging
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

