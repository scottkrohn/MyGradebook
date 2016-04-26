//  CSE 394 Class Project
//  Group: The Binary Canaries
//  --------------------------
//  File: WorkItem.swift
//  Author: John Rabatin
//  Lowest level object representing a single WorkItem in a Course, containing grade and category information.

import CoreData
import Foundation

class WorkItem: NSManagedObject {
    
    @NSManaged var pointsEarned: NSNumber?
    @NSManaged var pointsPossible: NSNumber?
    @NSManaged var category: String?
    @NSManaged var itemName: String?
}