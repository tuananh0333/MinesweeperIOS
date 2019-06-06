//
//  HomeScreenController.swift
//  game
//
//  Created by le tuan anh on 6/2/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

//import Foundation
import UIKit

class HomeScreenController: UIViewController {
    
    var isSound:Bool = true{
        didSet {
            if isSound {
                imgSound.image = UIImage(named: "soundon")
            } else {
                imgSound.image = UIImage(named: "soundoff")
            }
        }
    }
    
//    init() {
//        isSound = false
//    }
    
    @IBOutlet weak var imgSound: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func btnNewGame(_ sender: UIButton) {
    }
    @IBAction func btnScore(_ sender: UIButton) {
    }
    @IBAction func SwSound(_ sender: UISwitch) {
        isSound = !isSound
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
