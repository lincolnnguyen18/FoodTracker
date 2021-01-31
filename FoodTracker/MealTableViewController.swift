//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Lincoln Nguyen on 1/29/21.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: Properties and Setup
    /*
     Initialize empty array of meals
     Override viewDidLoad
         Call super
         Set navigationItem's leftBarButtonItem as editButtonItem
         If loadMeals returns meals then
             Load meals
         Else
             Call loadSampleMeals
     */
    var meals = [Meal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        if meals.count == 0 {
            loadSampleMeals()
        }
    }
    
    // MARK: Data Source Protocol Implementation
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
         Return configured cell
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
    
    // MARK: Delegate Methods
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: Navigation
    /*
     unwindToMealList function - destination view controller of unwind segue
         If source view controller can be downcasted into a MealViewController and its meal property is non-nil, store them into sourceViewController and meal
             If table view's index path for selected row is non-nil then save into selectedIndexPath
                 Update meal at selectedIndexPath.row in meals array to meal returned by source view controller
                 Reload row at selectedIndexPath
             Else
                 Create index path to new bottom row in table
                 Append meal retrieved from source view controller to table view controller's meals array
                 Call insertRows
             In either case (from ShowDetail update or from unwindToMealList new meal), call saveMeals
     */
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    /*
     Override prepare(for:sender:) - source view controller for unwind segue
         Call super
         Unwrap segueue identifier and switch it (identify segue)
             If AddItem then
                 Log "Adding a new meal."
             If ShowDetail then
                 Verify downcasted segue destination is MealViewController and save it
                 Verify downcasted sender is MealTableViewCell and save it
                 Verify indexPath of MealTableViewCell sender is in the table view controller
                 If all fail, call fatalError with "Unexpected Segue Identifier"
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nil sender")")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil identifier")")
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
    /*
     saveMeals function
         Call NSKeyedArchiver.archivedData for meals and save encoded object into data
         Try to write data into Meal.ArchiveURL
         If successful then
             Log "Meals successfully saved." (debug type)
         Else
             Log "Failed to save meals..." (error type)
     */
    private func saveMeals() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: Meal.ArchiveURL)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    /*
     loadMeals function
         Call Data(contentsOf:) on Meal.ArchiveUrl and store into data
         Call NSKeyedUnarchiver's unarchiveTopLevelObjectWithData on data and store as array of meals into meals
         Return meals
         Check for failure
     */
    private func loadMeals() -> [Meal]? {
        do {
            let data = try Data(contentsOf: Meal.ArchiveURL)
            let meals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Meal]
            return meals
        } catch {
            os_log("Failed to load meals...", log: OSLog.default, type: .error)
        }
        return meals
    }
}
