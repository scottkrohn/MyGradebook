//
//  AddWorkItemViewController.swift
//  GradeBook
//
//  Created by Scott & Jen on 4/21/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class AddWorkItemViewController: UIViewController {
    
    var semesterController: SemesterController = SemesterController();
    var currentCourse: Course?;
    var categoryName: String?;
    
    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var pointsPossible: UITextField!
    @IBOutlet weak var pointsEarned: UITextField!
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    // Validate user input for the assignment being added.
    func validateInput() -> Bool {
        
        var errorMessage: String = "";
        var errorOccured: Bool = false;
        
        // Make sure points possible field isn't blank or negative.
        if let possible = Double(pointsPossible.text!) {
            if(possible <= 0) {
                errorMessage = "Points possible must be positive.";
                errorOccured = true;
            }    
        }
        else {
            errorMessage = "Invalid input for points.";
            errorOccured = true;
        }
        
        // make sure points earned field isn't blank or negative.
        if let earned = Double(pointsEarned.text!) {
            if(earned <= 0) {
            errorMessage = "Points earned must be positive.";
            errorOccured = true;
        }
        }
        else {
            errorMessage = "Invalid input for points.";
            errorOccured = true;
        }
        
        // Make sure the assignment name field isn't blank.
        if(assignmentName.text == "") {
            errorMessage = "Invalid input for name";
            errorOccured = true;
        }
        
        // If an error occured, display the error in a pop up message.
        if(errorOccured == true) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert);
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false;
        }
        // if no error occured, return true.
        return true;
    }
    
    // Attempt to add an assignment to the Course.
    @IBAction func addAssignmentClicked(sender: AnyObject) {
        if(validateInput()) {
             semesterController.addWorkItemToCourse(currentCourse!, pointsPoss: Double(pointsPossible.text!)!, pointsEarned: Double(pointsEarned.text!)!, name: assignmentName.text!, category: categoryName!);
            self.navigationController?.popViewControllerAnimated(true);
        }
    }
    
}