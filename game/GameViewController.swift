//
//  ViewController.swift
//  game
//
//  Created by le tuan anh on 6/1/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var flagImage: [BoardModel.TouchMode: String] = [.normal: "flagging", .flag: "flagged"]
	
    @IBOutlet weak var stkBoard: ColumnStackController!
    @IBOutlet weak var lblBombNumber: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnFlagOutlet: UIButton!
    
    
    
    var board: BoardModel = BoardModel.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callback()
        
        //MARK: Create board
        stkBoard.setBoardSize(rows: 16, cols: 8)
    }
    
    func callback() {
        BoardModel.shareInstance.scoreUpdate = {
            [weak self] (score: Int) in self?.updateScore(score)
        }
        
        BoardModel.shareInstance.flaggedTilesChanged = {
            [weak self] (tilesCount: Int) in self?.flagTilesChanged(tilesCount)
        }
        
        BoardModel.shareInstance.isOver = {
            [weak self] (state: BoardModel.GameState) in self?.gamestateChanged(state)
        }
    }

    func updateScore(_ score: Int) {
        if lblScore != nil {
            lblScore.text = String(score)
        }
        print("Score: ", score)
    }
    
    func flagTilesChanged(_ tilesCount: Int) {
        if lblBombNumber != nil {
            lblBombNumber.text = String(board.mineAmount - tilesCount)
        }
        print("Flag number: ", board.mineAmount - tilesCount)
    }
    
    func gamestateChanged(_ state: BoardModel.GameState) {
        switch state {
        case .over:
            showGameOverDialog()
        default:
            //TODO: Reaction for other state
            break
        }
    }
    
    private func showGameOverDialog() {
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
        board.toggleFlag()
        
        guard let imageName = flagImage[board.touchMode] else {
            print("Image name is not defined")
            return
        }
        
        guard let btnFlagImage = UIImage(named: imageName) else {
            print(board.touchMode, "Image not found")
            return
        }
        
        sender.setBackgroundImage(btnFlagImage, for: .normal)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

