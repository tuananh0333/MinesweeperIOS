//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var flagImage: [GameController.TouchMode: String] = [.normal: "flagging", .flag: "flagged"]
    
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
    
    public var flags: Int = 0 {
        didSet {
            lblBombNumber.text = String(flags)
        }
    }
    
    var touchMode: GameController.TouchMode = .normal {
        didSet {
            guard let imageName = flagImage[touchMode] else {
                print("Image not found")
                return
            }
            
            if let image = UIImage(named: imageName) {
                btnFlagOutlet.setBackgroundImage(image, for: .normal)
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
        
        GameController.shareInstance.pointUpdate = { [weak self] (point: Int) in
            self?.useData(point: point)
        }
        
        //MARK: Create board
        stkBoard.setBoardSize(rows: 16, cols: 8)
    }

    func useData(point: Int) {
        lblScore.text = String(point)
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
        //FIXIT: Cai nay chi can callback tu datamodel la duoc
        if touchMode == .flag {
            touchMode = .normal
        }
        else {
            touchMode = .flag
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

