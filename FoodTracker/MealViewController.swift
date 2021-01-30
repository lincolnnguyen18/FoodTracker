//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

// View Controller (delegate of text field, image picker controller, and navigation controller)
class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties and Setup
    /*
     Set outlets
     Override viewDidLoad
         Call super
         Make view controller delegate of nameTextField
         If meal property non-nil (received from source view controller of unwind segue) then configure meal view controller to display data from meal property
         Enable saveButton only when textField is nonempty by calling updateSaveButtonState whenever view loads
     Override touchesBegan
         End editing
     */
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        updateSaveButtonState()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Text Field Delegate Actions
    /*
     Before text field returns
         Hide keyboard
     After text field editing begins
         Disable saveButton
     After text field editing ends
         Call updateSaveButtonState
         Set navigationItem's title to textField's text
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // MARK: Image Picker Controller Delegate Actions
    /*
     After picker cancelled
         Close it
     After picker finished
         Check if picked image is valid
         Set image view to picked image
         Close the picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
     }
    
    // MARK: Actions
    /*
     When image view is tapped
         Hide keyboard (if text field was active)
         Instantiate image picker controller
         Set its source to photo library
         Set its delegate to the view controller
         Show the picker
     */
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    /*
     cancel function
         Store whether or not presentingViewController is UINavigationController (whether current view is modal; ShowDetail) in isPresentingInAddMealMode
         If so, call dismiss(animated:completion:) without storing any data or calling the prepare(for:sender:) and unwindToMealList methods
         Else, unwrap the meal view's navigationController into owningNavigationController (check whether current view was pushed on navigation stack; AddItem) and call the navigation view's popViewController to pop the meal detail scene off the navigation stack
         Check for unwrap failure
     */
    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    /*
     Override prepare(for:sender:) - source view controller for unwind segue
         Call super
         Verify sender is a button and that it is the saveButton
         Unwrap text in nameTextFIeld into a constant
         Save currently selected photo and rating into constants
         Create meal with saved data
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Private Methods
    /*
     Private Methods
         updateSaveButtonState function
             Unwrap nameTextField text into constant
             Disable saveButton if string is empty
     */
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
