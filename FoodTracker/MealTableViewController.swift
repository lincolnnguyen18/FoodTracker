//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Lincoln Nguyen on 1/29/21.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties and Setup
    /*
     Initialize empty array of meals
     Override viewDidLoad
         Call super
         Load sample data
     */
    var meals = [Meal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()
    }
    
    // MARK: Table View Data Source Implementation
    /*
     Override numberOfSections
         Return 1
     Override tableView(_:numberOfRowsInSection:)
         Return meals array count
     Override tableView(_:cellForRowAt:)
         Create cell identifier
         Create cell by calling dequeueReusableCell and downcast returned table view cell into a meal table view cell
         Check for failure
         Get meal from meals array
         Configure cell with meal data
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        return cell
    }
    
    // MARK: Navigation
    /*
     unwindToMealList function - destination view controller of unwind segue
         If source view controller can be downcasted into a MealViewController and its meal property is non-nil then
             Create index path to new bottom row in table
             Append meal retrieved from source view controller to table view controller's meals array
             Call insertRows
     */
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    // MARK: Private Methods
    /*
     loadSampleMeals function
         Load sample photos
         Create meal objects and check for failure
         Add meal objects to meals array
     */
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal3 = Meal(name: "Paste with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal1")
        }
        meals += [meal1, meal2, meal3]
    }
}
