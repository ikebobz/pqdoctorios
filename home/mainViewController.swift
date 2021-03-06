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
    var map = [Int:track]()
    var qno = 0
    var errors = ""
    var oldVal:Double=0
    var courseId:String = ""
    var entries:[entry] = [entry]()
    struct track:Codable
    {
        let main:Int
        let sec:Int
    }
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
        let colnum : String
        let rownum : Int
        let content : String
    }
    var raw:[[[String]]] = [[[String]]]()
    var headers = [[String]]()
    func processinto2d(data:String) -> [[String]]
    {
        var transposed = [[String]]()
        let initial1d = data.components(separatedBy: ";")
        var initial2d = [[String]]()
        for onedarr in initial1d
        {
         initial2d.append(onedarr.components(separatedBy: ","))
        }
        transposed = transposer(source: initial2d)
        return transposed
    }
    func transposer(source:[[String]]) -> [[String]]
    {
        var copy:[[String]]
        if source.isEmpty {return source}
        copy = source.map{$0}
        if copy.first!.count > copy.last!.count
        {
            
            copy.removeLast()
        }
        var result = [[String]]()
        for index in 0..<copy.first!.count
        {
            result.append(copy.map{$0[index]})
        }
        return result
    }
    func addHeaders(source:String)
    {
       let headers = source.components(separatedBy: ",")
        self.headers.append(headers)
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        qindex.text = "Fetching Questions......"
        activityIndicator.hidesWhenStopped = true
        oldVal = uiStepper.value
        fetchAnswer()
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.destination is tabViewController
        {
            let vc = segue.destination as? tabViewController
            let val = map[qno]
            if val == nil {return}
            let noheaders = self.headers[val!.main].count
            vc?.headers = self.headers[val!.main]
            for index in 0..<noheaders
            {
             vc?.item.append(raw[val!.sec + index])
            }
        }
        if segue.destination is ImgViewController
        {
            let vc = segue.destination as? ImgViewController
            let parts = entries[qno].imageurl.components(separatedBy: "&")
            if parts.count > 1
            {
            vc?.figureLabel = parts[0]
            vc?.imageurl = parts[1]
            }
            else
            {
                vc?.imageurl = parts[0]
                vc?.figureLabel = "Question Figure"
            }
        }
        
        //let a = headers
        //let b = raw
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
        let tableInfo = entries[qno].content
        if entries[qno].content != "X"
        {
            /*uiBtnTable.backgroundColor=UIColor.cyan
            uiBtnTable.setTitleColor(UIColor.white, for: .normal)
            uiBtnTable.titleLabel?.text = "Table(" + String(tableInfo.components(separatedBy: "&").count) + ")"*/
            uiBtnTable.isEnabled = true
            
        }
        else
        {
            /*uiBtnTable.backgroundColor=UIColor.white
          uiBtnTable.setTitleColor(UIColor.cyan,for: .normal)
            uiBtnTable.titleLabel?.text = "Table"*/
            uiBtnTable.isEnabled = false
        }
        if entries[qno].imageurl != ""
        {uiBtnImage.isEnabled = true} else {uiBtnImage.isEnabled = false}
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
                        //let a = self.entries
                        if self.entries.count == 0
                        {
                        self.qindex.text = "Course not set"
                        UIAlertView(title: "Feedback", message:"Selected Course has not been set", delegate: nil, cancelButtonTitle: "OK").show()
                        }
                        else {
                        self.uiTextView.text = self.entries[self.qno].description
                        self.qindex.text = String(self.entries.count) + " questions"
                            if self.entries[self.qno].content == "X"
                            {self.uiBtnTable.isEnabled = false}
                            if self.entries[self.qno].imageurl == ""
                            {self.uiBtnTable.isEnabled = false}
                        UIAlertView(title: "Feedback", message:"Could not fetch entries..using cached version", delegate: nil, cancelButtonTitle: "OK").show()
                        }
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
                            var ctr1 = 0
                            var ctr2 = 0
                            
                        for eachEntry in feedback.data
                        {
                            self.entries.append(eachEntry)
                            if eachEntry.content != "X"
                            {
                        self.map[ctr1] = track(main: ctr2, sec: self.raw.count)
                        self.addHeaders(source: eachEntry.colnum)
                        let stringTable = eachEntry.content.components(separatedBy: "&")
                                for value in stringTable
                                {
                            self.raw.append(self.processinto2d(data: value))
                                }
                                
                                ctr2 = ctr2 + 1
                            }
                            ctr1 = ctr1 + 1
                        }
                        self.uiTextView.text = self.entries[self.qno].description
                        self.qindex.text = String(self.entries.count) + " questions"
                            if !self.persistEntres() {throw NSError(domain: "Caching unsuccessful", code: 41, userInfo: nil)}
                             self.savetoDevice()
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
            if details.imageurl == "" {
            newcourse.setValue(details.imageurl,forKey:"imageurl")
            } else
            {
                newcourse.setValue(editUrl(source:details.imageurl),forKey:"imageurl")
                
            }
            newcourse.setValue(details.course,forKey:"course")
            newcourse.setValue(details.colnum,forKey:"colnum")
            newcourse.setValue(String(details.rownum),forKey:"rownum")
            newcourse.setValue(details.content,forKey:"content")
            
        }
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
            var ctr1 = 0
            var ctr2 = 0
            let result = try context.fetch(frequest)
            for data in result as! [NSManagedObject]
            {
                let course = data.value(forKey: "course") as! String
                if course != courseId {continue}
                let qid = Int(data.value(forKey: "qid") as! String)
                let description = data.value(forKey: "question") as! String
                let answer = data.value(forKey: "answer") as! String
                let imageurl = data.value(forKey: "imageurl") as! String
                let rownum = Int(data.value(forKey: "rownum") as! String)
                let colnum = data.value(forKey: "colnum") as! String
                let content = data.value(forKey: "content") as! String
                let record = entry(qid: qid!, course: course, description: description, answer: answer, imageurl: imageurl,colnum:colnum,rownum:rownum!,content:content)
                entries.append(record)
                if content != "X"
                {
                    self.map[ctr1] = track(main: ctr2, sec: self.raw.count)
                    self.addHeaders(source:colnum)
                    let stringTable = content.components(separatedBy: "&")
                    for value in stringTable
                    {
                        self.raw.append(self.processinto2d(data: value))
                    }
                    
                    ctr2 = ctr2 + 1
                }
                    ctr1 = ctr1 + 1
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
        fetchRequest.predicate = NSPredicate(format: "course=%@",courseId as CVarArg)
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
    func editUrl(source:String) -> String
    {
     var edited:URL
     let srcurl = URL(string: source.components(separatedBy: "&")[1])
     edited = getDocumentsDirectory().appendingPathComponent(srcurl!.lastPathComponent)
     let path = edited.absoluteString
     return path
    }
    func getDocumentsDirectory() -> URL
    {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
    }
    func savetoDevice()
    {
        for entry in entries {
            if entry.imageurl != ""{
        let name = entry.imageurl
           let comps = name.components(separatedBy: "&")
           let srcuri = URL(string:comps[1])
           DispatchQueue.global().async{
            [weak self ] in
            if let data = try? Data(contentsOf: srcuri!){
                if let image = UIImage(data:data){
            //implement image saving here
                if let data = image.pngData(){
                let file = self?.editUrl(source:name)
                let filename = URL(string: file!)
                try? data.write(to:filename!)
                    }}}}}}}
}
