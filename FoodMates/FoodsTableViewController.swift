//
//  FoodsTableViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase
class FoodsTableViewController: UITableViewController {

    var foodsList: NSMutableArray?
    var ref: DatabaseReference?
    var selectedFood: Food?

    @IBOutlet weak var noItemsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        foodsList = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        if let currentUser = Auth.auth().currentUser {
            print("Logged in user is \(currentUser.displayName)")
            print("Logged in user is \(currentUser.email)")
        }
        
        retrieveDataFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {

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
        return (foodsList?.count)!
    }
    
    
    func retrieveDataFromFirebase()
    {
        // Retrieve the list of foods from Firebase
        ref?.child("Foods").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.foodsList?.removeAllObjects()
            var userID: String
            userID = "testuser2"
            for current in snapshot.children.allObjects as! [DataSnapshot]
            {
                userID = current.key
                if (userID != "testuser1")
                {
                    for currentFood in current.children.allObjects as! [DataSnapshot]
                    {
                        let value = currentFood.value as? NSDictionary
                        let foodName = value?["foodName"] as? String ?? ""
                        let foodDescription = value?["foodDescription"] as? String ?? ""
                        let imageURL = value?["imageURL"] as? String ?? ""
                        let foodDate = value?["foodDate"] as? String ?? ""
                        let newItem = Food(userID: userID, foodName: foodName, foodDescription: foodDescription, foodDate: foodDate, imageURL: imageURL)
                        self.foodsList?.add(newItem)
                    }
                }
            }
            self.tableView.reloadData()
            if self.foodsList?.count == 0
            {
                self.noItemsLabel.text = "No items to display"
            }
            else
            {
                self.noItemsLabel.text = ""
            }
        })

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell

        let food = foodsList?.object(at: indexPath.row) as! Food
        // Configure the cell...
        cell.labelFoodName.text = food.foodName
        cell.labelFoodDate.text = food.foodDate
        if (food.imageURL == "Blank")
        {
            cell.foodImageView.image = #imageLiteral(resourceName: "sampleimage")
        }
        else
        {
            let url = URL(string: food.imageURL)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                cell.foodImageView.image = image
            }
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFood = foodsList?.object(at: indexPath.row) as! Food
        performSegue(withIdentifier: "showFoodDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFoodDetailsSegue")
        {
            let destinationVC: FoodDetailsViewController = segue.destination as! FoodDetailsViewController
            destinationVC.currentFood = selectedFood
        }
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
