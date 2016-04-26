//
//  AddCategoryViewController.swift
//  GradeBook
//
//  Created by Scott & Jen on 4/19/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

protocol AddCategoryViewControllerDelegate {
    func response(categoryName: String, weight: Int);
}

class AddCategoryViewController: UIViewController {
    
    var delegate: AddCategoryViewControllerDelegate?
    var categories: Dictionary<String, Int> = Dictionary<String, Int>();
    var currentWeightTotal: Int = 0;
    
    @IBOutlet weak var nameBox: UITextField!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sliderUpdated(sender: AnyObject) {
        weightLabel.text = String(Int(weightSlider.value));
    }
    
    // Add a category to the course.
    @IBAction func addClicked(sender: AnyObject) {
        // Check if the weight input is valid.
        if((Int(weightSlider.value) + currentWeightTotal) <= 100) {
            // Check if the category name input is valid.
            if(nameBox.text == "") {
                 let alertController = UIAlertController(title: "Error", message: "You must enter a course name.", preferredStyle: UIAlertControllerStyle.Alert);
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)               
            }
            else {  // Category name input was invalid.
                self.delegate?.response(nameBox.text!, weight: Int(weightSlider.value));
                self.navigationController?.popViewControllerAnimated(true);
            }
        }
        else {  //  All inputs were valid.
            let alertController = UIAlertController(title: "Error", message: "Category weights will total more than 100. Please choose a lower value for weight.", preferredStyle: UIAlertControllerStyle.Alert);
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
}