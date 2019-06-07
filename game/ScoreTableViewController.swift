//
//  ScoreTableViewController.swift
//  Minesweeper
//
//  Created by le tuan anh on 6/5/19.
//  Copyright © 2019 CNTT-TDC. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {
    
    public static var scoreList = [Int]()
    var date = Date()

    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On being developed function, data just created to present as an example
        ScoreTableViewController.scoreList = [10, 20, 20, 10, 40, 100]
        ScoreTableViewController.scoreList.sort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ScoreTableViewController.scoreList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "score", for: indexPath) as? ScoreTableViewCell else {
            fatalError("can not get score")
        }
        if(indexPath.row == ScoreTableViewController.scoreList.count - 1 ) {
            cell.lblDate.text = "On being developed function, data just created to present as an example"
            cell.lblScore.text = ""
        } else {
        
        cell.lblDate.text = "07/06/2019"
        cell.lblScore.text = String(ScoreTableViewController.scoreList[(ScoreTableViewController.scoreList.count - 1) - indexPath.row])
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
