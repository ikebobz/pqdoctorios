//
//  mainViewController.swift
//  pqdoctor
//
//  Created by mac on 8/30/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
import CoreData

class mainViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uiStepper: UIStepper!
    @IBOutlet weak var uiBtnTable: UIButton!
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBOutlet weak var uiBtnImage: UIButton!
    @IBOutlet weak var uiTextView: UITextView!
    @IBOutlet weak var qindex: UILabel!
    var qno = 0
    var errors = ""
    var oldVal:Double=0
    var courseId:String = "MIT802"
    var entries:[entry] = [entry]()
    struct reply:Codable
    {
        let success:Int
        let data : [entry]
    }
    struct entry:Codable
    {
        var qid:Int
        let course:String
        let description:String
        let answer:String
        let imageurl:String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        qindex.text = "Fetching Questions......"
        activityIndicator.hidesWhenStopped = true
        oldVal = uiStepper.value
        fetchAnswer()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func switchToggle(_ sender: Any)
    {
    if entries.count == 0 {return}
    if uiSwitch.isOn
    {
    uiTextView.text = entries[qno].description
    }
    else
    {
     uiTextView.text = entries[qno].answer
    }
        
    }
    @IBAction func stepperPressed(_ sender: Any)
    {
    if entries.count == 0 {return}
    if uiStepper.value > oldVal
    {
     oldVal = oldVal + 1
     if qno < entries.count - 1
     {qno = qno + 1}
    
    }
    if uiStepper.value < oldVal
    {
     oldVal = oldVal - 1
     if(qno > 0)
     {qno = qno - 1}
    
    }
    
    uiTextView.text = entries[qno].description
    qindex.text = String(qno + 1) + "/"+String(entries.count)
    if !uiSwitch.isOn
    {
     uiSwitch.setOn(true, animated: false)
    }
    }
    
    func fetchAnswer()
    {
        activityIndicator.startAnimating()
        
        let url = URL(string:"http://192.168.178.44:8012/pqsolutions_webpart/getanswer.php/?course=\(courseId)&qdesc=%25")
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
                        self.uiTextView.text = self.entries[self.qno].description
                        self.qindex.text = String(self.entries.count) + " questions"
                        UIAlertView(title: "Feedback", message:"Could not fetch entries..using cached version", delegate: nil, cancelButtonTitle: "OK").show()
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
                        do{
                        for eachEntry in feedback.data
                        {
                            self.entries.append(eachEntry)
                        }
                        self.uiTextView.text = self.entries[self.qno].description
                        self.qindex.text = String(self.entries.count) + " questions"
                            if !self.persistEntres() {throw NSError(domain: "Caching unsuccessful", code: 41, userInfo: nil)}
                        UIAlertView(title: "Message", message: "Questions loaded successfully", delegate: nil, cancelButtonTitle: "OK").show()
                        
                        }
                        catch _ as NSError
                        {
                       UIAlertView(title: "Message", message: self.errors, delegate: nil, cancelButtonTitle: "OK").show()
                        }
                        
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
    func persistEntres() -> Bool
    {
        var success:Bool = true
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:"QINF",in:context)
        for details in entries
        {
            let newcourse = NSManagedObject(entity:entity!,insertInto:context)
            newcourse.setValue(String(details.qid),forKey:"qid")
            newcourse.setValue(details.description,forKey:"question")
            newcourse.setValue(details.answer,forKey:"answer")
            newcourse.setValue(details.imageurl,forKey:"imageurl")
            newcourse.setValue(details.course,forKey:"course")        }
        do
        {
            try context.save()
        }
        catch let err
        {
            success = false
            errors = err.localizedDescription
            
        }
        return success
    }
    func fetchData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let frequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QINF")
        frequest.returnsObjectsAsFaults = false
        do
        {
            
            let result = try context.fetch(frequest)
            for data in result as! [NSManagedObject]
            {
                
                let qid = Int(data.value(forKey: "qid") as! String)
                let description = data.value(forKey: "question") as! String
                let answer = data.value(forKey: "answer") as! String
                let course = data.value(forKey: "course") as! String
                let imageurl = data.value(forKey: "imageurl") as! String
                let record = entry(qid: qid!, course: course, description: description, answer: answer, imageurl: imageurl)
                entries.append(record)
            }
        }
        catch let err as NSError
        {
            
        }
    }
    func clearStore(verbosity:Int) -> Bool
    {
        var success = true
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QINF")
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
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
