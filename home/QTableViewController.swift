//
//  QTableViewController.swift
//  pqdoctor
//
//  Created by mac on 9/11/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
class CustomCell : UITableViewCell
{
    @IBOutlet weak var column3: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated:animated)
    }
    
}

class QTableViewController: UITableViewController {
    
    var items:[[String]] = [["ikenna","male","software engineer"],["ijeoma","female","lawyer"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        /*tableView.register(CustomCell.self, forCellReuseIdentifier: "cellID")
        self.tableView.dataSource = self
        self.tableView.delegate = self*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var colsize = 0
        var xindex = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! CustomCell
        while colsize < items[0].count
        {
            let field = UILabel(frame:CGRect(x:xindex + 10,y:0,width:200,height:60))
            field.font = UIFont.systemFont(ofSize: 15)
            field.numberOfLines = 0
            field.text = items[indexPath.row][colsize]
            cell.contentView.addSubview(field)
            colsize = colsize + 1
            xindex = xindex + 100
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
