# Meal View Controller (delegate of text field, image picker controller, and navigation controller)
### Properties and Setup
        Set outlets
        Declare optional meal
        Override viewDidLoad
            Call super
            Make view controller delegate of nameTextField
            If meal property non-nil (received from source view controller of unwind segue) then configure meal view controller to display data from meal property
            Enable saveButton only when textField is nonempty by calling updateSaveButtonState whenever view loads
        Override touchesBegan
            End editing
### Text Field Delegate Actions
        Before text field returns
            Hide keyboard
        After text field editing begins
            Disable saveButton
        After text field editing ends
            Call updateSaveButtonState
            Set navigationItem's title to textField's text
### Image Picker Controller Delegate Actions
        After picker cancelled
            Close it
        After picker finished
            Check if picked image is valid
            Set image view to picked image
            Close the picker
### Actions
        When image view is tapped
            Hide keyboard (if text field was active)
            Instantiate image picker controller
            Set its source to photo library
            Set its delegate to the view controller
            Show the picker
### Navigation
        cancel function
            Store whether or not presentingViewController is UINavigationController (whether current view is modal; ShowDetail) in isPresentingInAddMealMode
            If so, call dismiss(animated:completion:) without storing any data or calling the prepare(for:sender:) and unwindToMealList methods
            Else, unwrap the meal view's navigationController into owningNavigationController (check whether current view was pushed on navigation stack; AddItem) and call popViewController to pop the meal detail scene off the navigation stack
            Check for unwrap failure
        Override prepare(for:sender:) - source view controller for unwind segue
            Call super
            Verify sender is a button and that it is the saveButton
            Unwrap text in nameTextFIeld into a constant
            Save currently selected photo and rating into constants
            Create meal with saved data
### Private Methods
        updateSaveButtonState function
            Unwrap nameTextField text into constant
            Disable saveButton if string is empty

# Rating Controller
### Rating Controller Properties
        Initialize empty array of buttons
        Initialize integer rating
        After rating integer set, update button selection states
        Initialize CGSize star size and star count
        Call setupButtons whenever either of these are changed
### Initialize Buttons
        Override interface builder init to call super and setupButtons
        Implement required storyboard runtime init to call super and setupButtons
### Button Action
        ratingButtonTapped function
            Check that selected button returns valid index
            If index + 1 == rating then reset rating to 0
            Else, set rating to index + 1
### Private Methods
        setupButtons function
            Loop through buttons array
                Remove each from stackview array
                Remove each from stackview superview
            Clear buttons array
            Get bundle
            Load images for filledStar, emptyStawr, and highlightedStar from bundle
            For starCount times
                Initialize button
                Set its image according to its state
                Constrain button
                Attach ratingButtonTapped to button
                Add button to stackview superview
                Add button to buttons array
### updateButtonSelectionStates function
            Loop through (index, button) of enumerated buttons array
                If button's index < current rating then set its state as selected

# Meal Data Model (subclasses NSObject and conforms to NSCoding protocol)

### Properties
        Initialize name, optional photo, and rating variables
### Archiving Paths
        Call FileManager's ulrs(for:in:) method for array of URLs and force unwrap the first URL into static constant DocumentsDirectory
        Append "meals" to end of DocumentsDirectory URL and save in static constant ArchiveURL
### Types
        Declare PropertyKey structure
            Declare static constant properties of structure (name, photo, rating)
### Failable Init
        Check name is not empty
        Check rating is in [0, 5]
        If so, initialize stored properties
### NSCoding Data Persistence
        encode(with:) function
            Encode the value of each property of meal and store them with their corresponding key in PropertyKey
        implement failable conveience init required by NSObject subclass
            Guard unwrap optional and downcast decoded object for PropertyKey.name into constant
            Unwrap optional and downcast decoded object for PropertyKey.photo int constant
            Unarchive int for PropertyKey.rating into constant
            Call designated initializer

# Unit Tests
### testMealInitializationSucceeds function
        Test meal with rating of 0
        Test meal with rating of 5
### testMealInitializationFails function
        Test meal with negative rating
        Test meal with rating of 6
        Test meal with empty string name

# Meal Table View Cell
    
# Meal Table View Controller
### Properties and Setup
        Initialize empty array of meals
        Override viewDidLoad
            Call super
            Set navigationItem's leftBarButtonItem as editButtonItem
            Call loadMeals into savedMeals and add savedMeals to meals array
            If meals array is empty then call loadSampleMeals
### Data Source Protocol Implementation
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
### Delegate Methods
        Override tableView(_:commit:forRowAt:)
            If editingStyle is delete then
                Remove meal at indexPath.row in meals array
                Call saveMeals
                Delete row at indexPath in tableView controller
            Else if editingStyle is insert then
### Navigation
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
        Override prepare(for:sender:) - source view controller for unwind segue
            Call super
            Unwrap segueue identifier and switch it (identify segue)
                If AddItem then
                    Log "Adding a new meal."
                If ShowDetail then
                    Verify downcasted segue destination is MealViewController and save it into mealDetailViewController
                    Verify downcasted sender is MealTableViewCell and save it into selectedMealCell
                    Verify indexPath of MealTableViewCell sender is in the table view controller and save it into indexPath
                    Get meal at indexPath.row in meals array and save it into selectedMeal
                    Set mealDetailViewController's meal to selected meal
                If all fail, call fatalError with "Unexpected Segue Identifier"
### Private Methods
        loadSampleMeals function
            Load sample photos
            Create meal objects and check for failure
            Add meal objects to meals array
        saveMeals function
            Call NSKeyedArchiver.archivedData for meals and save encoded object into data
            Try to write data into Meal.ArchiveURL
            If successful then
                Log "Meals successfully saved." (debug type)
            Else
                Log "Failed to save meals..." (error type)
        loadMeals function
            Call Data(contentsOf:) on Meal.ArchiveUrl and store into data
            Call NSKeyedUnarchiver's unarchiveTopLevelObjectWithData on data and store as array of meals into meals
            Return meals
            Check for failure
