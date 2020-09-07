//
//  mainViewController.swift
//  pqdoctor
//
//  Created by mac on 8/30/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uiStepper: UIStepper!
    @IBOutlet weak var uiBtnTable: UIButton!
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBOutlet weak var uiBtnImage: UIButton!
    @IBOutlet weak var uiTextView: UITextView!
    @IBOutlet weak var qindex: UILabel!
    var qno = 0
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
        let qid:Int
        let course:String
        let description:String
        let answer:String
        let imageurl:String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        oldVal = uiStepper.value
        //uiStepper.minimumValue = 0
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
                        //self.fetchData()
                        UIAlertView(title: "Feedback", message:"Could not fetch entries", delegate: nil, cancelButtonTitle: "OK").show()
                        self.activityIndicator.stopAnimating()
                }
                return
            }
            
            if let feedback = try? JSONDecoder().decode(reply.self,from:data)
            {
                DispatchQueue.main.async {
                    if !feedback.data.isEmpty
                    {
                        for eachEntry in feedback.data
                        {
                            self.entries.append(eachEntry)
                        }
                        self.uiTextView.text = self.entries[self.qno].description
                        self.qindex.text = String(self.entries.count) + " questions"
                        UIAlertView(title: "Message", message: "Questions loaded successfully", delegate: nil, cancelButtonTitle: "OK").show()
                        //self.commit(courses: feedback.data)
                        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
