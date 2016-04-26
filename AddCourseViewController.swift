//
//  AddCourseViewController.swift
//  GradeBook
//
//  Created by Lazaro Ortiz on 4/19/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, AddCategoryViewControllerDelegate {
    
    var semesterController: SemesterController = SemesterController();
    var selectedSemeter: Semester?
    var categoryWeightTotal: Int = 0;
    
    var categories: Dictionary<String, Int> = Dictionary<String, Int>();
    var categoryNames: [String] = Array<String>();
    var categoryWeights: [Int] = Array<Int>();
    
    
    @IBOutlet weak var courseNameBox: UITextField!
    @IBOutlet weak var categoryTable: UITableView!
    
    func response(categoryName: String, weight: Int) {
        categories[categoryName] = weight;
        categoryNames.append(categoryName);
        categoryWeights.append(weight);
        // Keep running total of category weights.
        categoryWeightTotal += weight;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        categoryTable.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Add the course to the semester.
    @IBAction func addCourseClicked(sender: AnyObject) {
        let courseName = courseNameBox.text;
        // Check if the user entered a course name.
        if(courseName == "") {
            let alertController = UIAlertController(title: "Error", message: "You must enter a course name.", preferredStyle: UIAlertControllerStyle.Alert);
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        // Check if the weights add up to 100%
        else if (categoryWeightTotal != 100){
            let alertController = UIAlertController(title: "Error", message: "Category weights total must equal 100%", preferredStyle: UIAlertControllerStyle.Alert);
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {  // Input was valid.
            semesterController.addCourseToSemester(selectedSemeter!, courseName: courseName!, categories: categories);
            self.navigationController?.popViewControllerAnimated(true);
        }
        
    }
    
    // Send data to next view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as? AddCategoryViewController;
        nextView?.currentWeightTotal = categoryWeightTotal;
        nextView?.delegate = self;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    // Delegate function: populate the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath)
        cell.textLabel!.text = categoryNames[indexPath.item];
        cell.detailTextLabel!.text = String(categoryWeights[indexPath.item]) + String("%");
        return cell
    }
    
    
    // Facilitate deleting data from the table view.
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            categoryWeightTotal -= categoryWeights[indexPath.item];
            categories.removeValueForKey(categoryNames[indexPath.item]);
            categoryWeights.removeAtIndex(indexPath.item);
            categoryNames.removeAtIndex(indexPath.item);
            categoryTable.reloadData();
        }
    }
    
    // Display the ASU class search mobile view.
    @IBAction func searchClicked(sender: AnyObject) {
        let url = NSURL(string: "https://webapp4.asu.edu/catalog/Home.ext");
        UIApplication.sharedApplication().openURL(url!);
    }
}

