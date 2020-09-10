//
//  appMapViewController.swift
//  pqdoctor
//
//  Created by mac on 8/22/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
import CoreData

class appMapViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBAction func loadCourse(_ sender: Any)
    {
    performSegue(withIdentifier: "_toMain", sender: self)
    }
    @IBOutlet weak var btnLoad: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.courseid = viewOptions[row]
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.destination is mainViewController
       {
        let vc = segue.destination as? mainViewController
        vc?.courseId = self.courseid
       }
    }
    
    @IBOutlet weak var picker: UIPickerView!
    var viewOptions:[String] = [String]()
    var courseid = ""
    struct reply:Codable
    {
        let success:Int
        let data : [course]
    }
    struct course:Codable
    {
        let code:String
        let description:String
    }
    var courses:[course] = [course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        getCourses()
        
        
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   func getCourses()
   {
    
    activityIndicator.startAnimating()
    
    let url = URL(string:"http://192.168.178.44:8012/pqsolutions_webpart/getcourses.php")
    var request = URLRequest(url: url!)
    
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request)
    {
        data,response,error in
        
        guard let data = data,error == nil else
        {
            DispatchQueue.main.async
                {
                 self.fetchData()
        UIAlertView(title: "Feedback", message:"Could not update courses,using a cached version", delegate: nil, cancelButtonTitle: "OK").show()
                    self.activityIndicator.stopAnimating()
            }
            return
        }
    
        if let feedback = try? JSONDecoder().decode(reply.self,from:data)
        {
            self.clearStore(verbosity: 0)
            DispatchQueue.main.async {
                if !feedback.data.isEmpty
                {
                    self.picker.delegate = self
                    self.picker.dataSource = self
                    for details in feedback.data
                    {
                 self.viewOptions.append(details.code)
                    }
           let commitState = self.commit(courses: feedback.data)
                    if commitState {
        UIAlertView(title: "Message", message: "Courses successfully loaded", delegate: nil, cancelButtonTitle: "OK").show()                    }
                    else {
  UIAlertView(title: "Message", message: "Cache unsuccessful", delegate: nil, cancelButtonTitle: "OK").show()
                    }
        /*{
         UIAlertView(title: "Message", message: "Success Saving Data", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else{
        UIAlertView(title: "Message", message: "Failure Saving Data", delegate: nil, cancelButtonTitle: "OK").show()                    }*/
        }
                else
                {
                    UIAlertView(title: "Message", message: "Courses have not being set", delegate: nil, cancelButtonTitle: "OK").show()
                }
                self.activityIndicator.stopAnimating()
            }
        }
        
        
        }.resume()
   }
    func commit(courses:[course]) -> Bool
    {
    var success:Bool = true
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName:"COURSE",in:context)
    for details in courses
    {
    
    let newcourse = NSManagedObject(entity:entity!,insertInto:context)
    newcourse.setValue(details.code,forKey:"courseid")
    newcourse.setValue(details.description,forKey:"courseinfo")
        
    }
        do
        {
         try context.save()
        }
        catch
        {
          success = false
        }
    return success
    }
    func clearStore(verbosity:Int) -> Bool
    {
        var success = true
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "COURSE")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do
        {
          try context.execute(batchDeleteRequest)
            if verbosity == 1
            {
                UIAlertView(title: "Message", message: "Success Deleting", delegate: nil, cancelButtonTitle: "OK").show()
                
            }
            
        }
        catch
        {
        success = false
        }
        return success
    }
    func fetchData() -> [String]
    {
     var ids = [String]()
     let appDel = UIApplication.shared.delegate as! AppDelegate
     let context = appDel.persistentContainer.viewContext
     let frequest = NSFetchRequest<NSFetchRequestResult>(entityName: "COURSE")
     frequest.returnsObjectsAsFaults = false
     do
     {
        
        let result = try context.fetch(frequest)
        self.picker.delegate = self
        self.picker.dataSource = self
        for data in result as! [NSManagedObject]
        {
            let ccode = data.value(forKey: "courseid") as! String
            self.viewOptions.append(ccode)
            ids.append(ccode)
            }
    }
     catch
     {
        
     }
        return ids
    }
}
