//
//  ViewController.swift
//  Minesweeper
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
        
        startGame()
    }
    
    func startGame() {
        //MARK: Create board
        board.resetBoardProperties()
        board.setupTileField()
        
        stkBoard.setupButton()
    }
    
    func callback() {
        board.scoreUpdate = {
            [weak self] (score: Int) in self?.updateScore(score)
        }
        
        board.flaggedTilesChanged = {
            [weak self] (tilesCount: Int) in self?.flagTilesChanged(tilesCount)
        }
        
        board.gameStateChanged = {
            [weak self] (state: BoardModel.GameState) in self?.gameStateChanged(state)
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
    
    func gameStateChanged(_ state: BoardModel.GameState) {
        switch state {
        case .over:
            showDialog(title: "Game over", message: "Your score: \(String(describing: lblScore.text!)) \nBack to home?")
        case .win:
            showDialog(title: "You won!", message: "Back to home?")
        case .playing:
            break
        }
    }
    
    private func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnBackToHome(_ sender: UIButton) {
        showDialog(title: "Back to home", message: "Back to home will stop your current game")
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
}

