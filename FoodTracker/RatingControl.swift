//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Lincoln Nguyen on 1/29/21.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Rating Controller Properties
    /*
     Initialize empty array of buttons
     Initialize integer rating
     After rating integer set, update button selection states
     Initialize CGSize star size and star count
     Call setupButtons whenever either of these are changed
     */
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 0 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialize Buttons
    /*
     Override interface builder init to call super and setupButtons
     Implement required storyboard runtime init to call super and setupButtons
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
    /*
     ratingButtonTapped function
         Check that selected button returns valid index
         If index + 1 == rating then reset rating to 0
         Else, set rating to index + 1
     */
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        if index + 1 == rating {
            rating = 0
        } else {
            rating = index + 1
        }
    }
    
    // MARK: Private Methods
    /*
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
     */
    private func setupButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        //let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            //button.setImage(highlightedStar, for: .highlighted)
            //button.setImage(highlightedStar, for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    /*
     updateButtonSelectionStates function
         Loop through (index, button) of enumerated buttons array
             If button's index < current rating then set its state as selected
     */
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
