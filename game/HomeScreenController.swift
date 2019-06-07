//
//  HomeScreenController.swift
//  Minesweeper
//
//  Created by le tuan anh on 6/2/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

//import Foundation
import UIKit

class HomeScreenController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var isSound = false {
        didSet {
            if isSound {
                btnSound.setImage(UIImage(named: "soundon"), for: .normal)
            } else {
                btnSound.setImage(UIImage(named: "soundoff"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var pkvDifficult: UIPickerView!
    @IBOutlet weak var btnSound: UIButton!
    
    let gradePickerValues = ["Easy", "Medium", "Hard", "Demo"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradePickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            BoardModel.shareInstance.difficult = .easy
        case 1:
            BoardModel.shareInstance.difficult = .normal
        case 2:
            BoardModel.shareInstance.difficult = .hard
        case 3:
            BoardModel.shareInstance.difficult = .demo
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pkvDifficult.dataSource = self
        pkvDifficult.delegate = self
        pkvDifficult.isHidden = false
    }
    @IBAction func btnSound(_ sender: UIButton) {
        isSound = !isSound
    } 
}
