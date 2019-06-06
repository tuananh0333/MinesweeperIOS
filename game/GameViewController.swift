//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
    @IBOutlet weak var stkBoard: ColumnStackController!
    @IBOutlet weak var lblBombNumber: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnFlagOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callback()
        
        //MARK: Create board
        stkBoard.setBoardSize(rows: 16, cols: 8)
    }
    
    func callback() {
        GameModel.shareInstance.scoreUpdate = {
            [weak self] (score: Int) in self?.updateScore(score)
        }

        GameModel.shareInstance.touchModeUpdate = {
            [weak self] (touchMode: GameModel.TouchMode) in self?.toggleFlagButton(touchMode)
        }
        
        GameModel.shareInstance.isOver = {
            [weak self] (state: Bool) in self?.isOver(state)
        }
    }

    func updateScore(_ score: Int) {
        lblScore.text = String(score)
    }
        
    func toggleFlagButton(_ touchMode: GameModel.TouchMode) {
        guard let imageName = GameModel.shareInstance.flagImage[touchMode] else {
            print("Image not found")
            return
        }
        
        if let image = UIImage(named: imageName) {
            btnFlagOutlet.setBackgroundImage(image, for: .normal)
        }
    }
    
    func isOver(_ state: Bool) {
        // Create back to home dialog
        let alert = UIAlertController(title: "Game Over", message: "Back to home?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        GameModel.shareInstance.toggleFlag()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

