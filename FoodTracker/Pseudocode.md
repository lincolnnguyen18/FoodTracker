# Meal View Controller (delegate of text field, image picker controller, and navigation controller)
### Properties and Setup
        Set outlets
        Declare optional meal
        Override viewDidLoad
            Call super
            Make view controller delegate of nameTextField
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
        Override prepare(for:sender:) - source view controller for unwind segue
            Call super
            Verify sender is a button and that it is the saveButton
            Unwrap text in nameTextFIeld into a constant
            Save currently selected photo and rating into constants
            Create meal with saved data
        cancel function
            Close meal view controller modal scene without storing any data or calling the prepare(for:sender:) and unwindToMealList methods
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

# Meal Data Model
### Meal Properties
        Initialize name, optional photo, and rating variables
### Meal Failable Init
        Check name is not empty
        Check rating is in [0, 5]
        If so, initialize stored properties

### Meal Class Unit Tests
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
            Load sample data
### Table View Data Source Implementation
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
### Navigation
        unwindToMealList function - destination view controller of unwind segue
            If source view controller can be downcasted into a MealViewController and its meal property is non-nil then
                Create index path to new bottom row in table
                Append meal retrieved from source view controller to table view controller's meals array
                Call insertRows
### Private Methods
        loadSampleMeals function
            Load sample photos
            Create meal objects and check for failure
            Add meal objects to meals array
