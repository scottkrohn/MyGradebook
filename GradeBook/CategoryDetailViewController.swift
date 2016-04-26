//
//  CategoryDetailViewController.swift
//  GradeBook
//
//  Created by Scott & Jen on 4/21/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    var semesterController: SemesterController = SemesterController();
    var currentCourse: Course?;
    var categoryName: String?;
    var workItems: [WorkItem]?;
    var categoryMatchingItems: [WorkItem]? = Array<WorkItem>();
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var categoryGradeLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        workItems = ((currentCourse?.mutableSetValueForKey("workItems"))?.allObjects as! [WorkItem]);
        loadCategoryWorkItems();
        calcCategoryGrade();
        navBar.title = currentCourse!.courseName! + " - " + categoryName!;
    }
    
    // Reload data when the view comes into focus.
    override func viewDidAppear(animated: Bool) {
        workItems = ((currentCourse?.mutableSetValueForKey("workItems"))?.allObjects as! [WorkItem]);
        loadCategoryWorkItems();
        categoryTable.reloadData();
        calcCategoryGrade();
    }
    
    // Load the work items that correspond to the selected category.
    private func loadCategoryWorkItems() {
        categoryMatchingItems?.removeAll();
        for(var i = 0; i < workItems!.count; i++) {
            if(workItems![i].category == categoryName) {
                categoryMatchingItems?.append(workItems![i]);
            } 
        }
    }
    
    // Display the current grade for the category.
    private func calcCategoryGrade() {
        categoryGradeLabel.text = "Current Category Grade: " + String(format: "%.2f", (semesterController.calcCategoryGrade(currentCourse!, categoryName: categoryName!)) * 100) + "%";
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    // Facilitate deleting data from the table view.
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            semesterController.deleteWorkItem(workItems![indexPath.item]);
            workItems?.removeAtIndex(indexPath.item);
            loadCategoryWorkItems();
            categoryTable.reloadData();
            calcCategoryGrade();
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryMatchingItems!.count;
    }
    
    // Delegate function: populate the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath)
        cell.textLabel!.text = categoryMatchingItems![indexPath.item].itemName;
        cell.detailTextLabel!.text  = String(format: "%.2f", Double(categoryMatchingItems![indexPath.item].pointsEarned!)) + "/" + String(format: "%.2f", Double(categoryMatchingItems![indexPath.item].pointsPossible!));
        return cell
    }
    
    // Send data to next view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addWorkItemSegue" {
            if let workItemViewController = segue.destinationViewController as? AddWorkItemViewController {
                workItemViewController.currentCourse = currentCourse;
                workItemViewController.categoryName = categoryName;
            }
        }
    }
}
