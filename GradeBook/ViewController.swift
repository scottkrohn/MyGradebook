//
//  ViewController.swift
//  GradeBook
//
//  Created by IEUser on 3/24/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    // Outlets
    @IBOutlet weak var semesterTable: UITableView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var jobTitleField: UITextField!
    @IBOutlet weak var numJobsLabel: UILabel!
    @IBOutlet weak var overallGPA: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    // Data members
    var semesterController: SemesterController! = SemesterController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.image = UIImage(named: "Logo.png");
        overallGPA.text = String(format: "%.2f", semesterController.calcCumulativeGPA());
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Reload data for the table view when view appears.
    override func viewDidAppear(animated: Bool) {
        semesterTable.reloadData();
        overallGPA.text = String(format: "%.2f", semesterController.calcCumulativeGPA());
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegate function: indicate number of rows for table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesterController.getSemesterCount();
    }
    
    // Deleate function: populate the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath)
        cell.textLabel?.text = semesterController.getTerm(indexPath);
        return cell
    }
    
    // Facilitate deleting data from the table view.
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            semesterController.deleteSemester(indexPath);
            semesterTable.reloadData();
            overallGPA.text = String(format: "%.2f", semesterController.calcCumulativeGPA());
        }
    }
    
    // Perform RESTful query to the Glassdoor API to get job data for a specific career.
    @IBAction func searchJobs(sender: AnyObject) {
        let city = cityField.text!
        let state = stateField.text!
        let jobTitle = jobTitleField.text!
        let partnerId = 61930
        let apiKey = "bSwVXJhnlBS"
        
        print(city)
        print(state)
        print(jobTitle)
        
        if (city.characters.count > 0 && state.characters.count > 0 && jobTitle.characters.count > 0) {
            let urlAsString = "http://api.glassdoor.com/api/api.htm?t.p=\(partnerId)&t.k=\(apiKey)&userip=0.0.0.0&useragent=&format=json&city=\(city)&state=\(state)&v=1&action=jobs-stats&returnCities=true&jt=\(jobTitle)"
            let encodedUrlString = urlAsString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let url = NSURL(string: encodedUrlString)!
            let urlSession = NSURLSession.sharedSession()
            print(encodedUrlString)
            var numJobs = 0
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                
                let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                print(jsonResult)
                let jobsInfo = jsonResult["response"] as! NSDictionary
                for city in jobsInfo["cities"] as! [Dictionary<String, AnyObject>] {
                    numJobs = numJobs + (city["numJobs"] as! NSInteger)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.numJobsLabel.text = "# Jobs: \(numJobs)"
                })
            })
            jsonQuery.resume()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "courseListSegue") {
            if let courseListViewController = segue.destinationViewController as? CourseDetailViewController {
                courseListViewController.selectedSemester = semesterController.getSemester(semesterTable.indexPathForSelectedRow!);
            }
        }
    }
}

