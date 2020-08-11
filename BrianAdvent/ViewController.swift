//
//  ViewController.swift
//  BrianAdvent
//
//  Created by H M on 11/9/19.
//  Copyright © 2019 H M. All rights reserved.
//
//project built from: brainadvent.com/build-simple-core-data-driven-ios-app/
//Info re: Managed object in "Getting Started - Beginning Core Data" by raywenderlich.com Aug 1, 2017

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return bg_record_TimeStamp_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 1
        let bg_record_TimeStamp_item = bg_record_TimeStamp_items[indexPath.row]
        
        ////////  Title for each cell
        // 2
        let recordTime = bg_record_TimeStamp_item.time as! Date
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        let dateFormatter0 = DateFormatter()
        dateFormatter0.dateFormat = "MM/dd/yy"
        dateFormatter1.dateFormat = "hh:mm:ss"
        dateFormatter2.dateFormat = "hh:mm"
        //cell.detailTextLabel?.text = dateFormatter1.string(from: recordTime)
        //cell.detailTextLabel?.text = dateFormatter2.string(from: recordTime)
        cell.textLabel?.text = dateFormatter0.string(from: recordTime)
        
        ////////  Subtitle for each cell
        // 3
        cell.detailTextLabel?.text = dateFormatter2.string(from: recordTime)
        
        // 4
        
        
    return cell
    }
    
    
    // 1
    //create an array for each Entity in the DB.
    var bg_record_TimeStamp_items = [TimeStamp]()
    var bg_record_GlucoseValue = [GlucoseValue]()
    var bg_record_ManualBGReadings_items = [ManualBGReading]()
    var bg_record_SensorReadings_items = [SensorReading]()
    
    // 2
    //The ManagedObjectContext is a container that holds a bunch of ManagedObjects.
    //ManagedObject is a class that representing a single data record
    var moc:NSManagedObjectContext!
    //inititalize this in the view did load function - //4
    // 3
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Broken here
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Connects the RecordTableView here
    @IBOutlet weak var RecordTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    // 4
        moc = appDelegate?.persistentContainer.viewContext
        
        self.RecordTableView.dataSource = self
        
        loadData()
        
    } //end func viewDidLoad
    
    //Add button logic here
    //This applies to Add Time Button & Add Manual BG Button. click control and drag button here. Each button is id'ed by a tag 1 and tag 2.
    @IBAction func addDataToDB(_ sender: UIButton) {
        
        let bg_record_TimeStamp_items = TimeStamp(context: moc)
        let bg_record_ManualBGReadings_items = ManualBGReading(context: moc)
        
       
        //print("Date stored in DB: ",  bg_record_TimeStamp_items.time!)
        
////////////////////////////////////////////////////////////////////////   TO DO ////////////////////////////////////////////////////////////////////////////////////
//          Make this date format the same as output from CGM
//          Why is the date incorrect???? What is my systems location?
//////////////////////////////////////////////////////////////////////// ////////////////////////////////////////// ///////////////////////////////////////////////////////
        //bg_record_ManualBGReadings_items.glucoseReading = //input
        
        if sender.tag == 1{
            
            //Add Time
             bg_record_TimeStamp_items.time = NSDate() as Date//input from textfield
            //Add hasTimestamp because this is not an optional value
             bg_record_ManualBGReadings_items.hasTimestamp = false
          
            print("Time Button clicked: \n", "Time = ", bg_record_TimeStamp_items.time! , "\n Data stored in DB.")
            
        }
        else if sender.tag == 2{  //Add Manual BG Button was clicked
            
            //This will associate a BG reading with current time.
            
            //Add Time
            bg_record_TimeStamp_items.time = NSDate() as Date//input from textfield
            //Add manual BG
            bg_record_ManualBGReadings_items.glucoseReading = 100
            bg_record_ManualBGReadings_items.hasTimestamp = true
            
            
            print("ManBG Button clicked: \n",  "BG = ", bg_record_ManualBGReadings_items.glucoseReading , "Time = ", bg_record_TimeStamp_items.time!, "\n",
                "Data stored in DB. \n")
            
        }
        else{
            print("No buttons were clicked.")
        }
        
        //XCode saves the information inside our object using a function from AppDelegate. Its saves the info to the database.
        appDelegate?.saveContext()
        //Displays information from the newly created item in the UI
        loadData()
    }
    
    func loadData()
    {
        // 1
        let recordRequest:NSFetchRequest<TimeStamp> = TimeStamp.fetchRequest()
        
        // 2
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        recordRequest.sortDescriptors = [sortDescriptor]
        
        // 3
        do {
            try bg_record_TimeStamp_items = moc.fetch(recordRequest)
            
        } catch {
            print("could not load data into UI RecordTableView")
        }
        
        // 4
        self.RecordTableView.reloadData()
    }
    
} //end class ViewController: UIViewController

