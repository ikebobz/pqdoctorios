//
//  ViewController.swift
//  pqdoctor
//
//  Created by mac on 8/8/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var modesel: UISwitch!
    var user = "",password = ""
    static var root = "",uname = ""
    var finished = false
    var credentials = [String:String]()
    var jsObject:NSMutableDictionary = NSMutableDictionary()
    var baseurl = "http://192.168.178.44:8012/pqsolutions_webpart/"
    struct result:Codable
    {   let success:Int
        let data:[credentials]
    }
    struct credentials:Codable
    {
        let email:String
        let pass:String
        //let key:String
    }
    struct cerror:Codable
    {
        let success:Int
        let message:String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appSetup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func appSetup() -> Void
    {
        activityIndicator.hidesWhenStopped = true
        let defaults = UserDefaults.standard
        uname.text = defaults.string(forKey:"username")
        pass.text = defaults.string(forKey:"password")

    }

    @IBAction func _register(_ sender: Any) {
        /*let vwctr:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hview") as UIViewController
        self.present(vwctr, animated: true, completion: nil)   */ }
    
    
    @IBAction func _signIn(_ sender: Any) {
        if !modesel.isOn
        {
        self.performSegue(withIdentifier: "_toHome", sender: self) 
        return
        }
        let defaults = UserDefaults.standard
        defaults.set(uname.text,forKey:"username")
        defaults.set(pass.text,forKey:"password")
        activityIndicator.startAnimating()
        
        let url = URL(string:baseurl + "authorize.php/?email="+uname.text!)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request)
        {
            data,response,error in
            
            guard let data = data,error == nil else
            {
                DispatchQueue.main.async
                    {
                        UIAlertView(title: "Feedback", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
                        self.activityIndicator.stopAnimating()
                }
                return
            }
            if let feedback = try? JSONDecoder().decode(result.self,from:data)
            {
                DispatchQueue.main.async {
                    if !feedback.data.isEmpty
                    {
                        if feedback.data[0].email == self.uname.text && feedback.data[0].pass == self.pass.text{
               /*UIAlertView(title: "Login", message: "Successful Login", delegate: nil, cancelButtonTitle: "OK").show()*/
                self.performSegue(withIdentifier: "_toHome", sender: self)
                        } else
                        {
                   UIAlertView(title: "Login", message: "Wrong username/password pair", delegate: nil, cancelButtonTitle: "OK").show()
                        }
                    }
                    else
                    {
                 UIAlertView(title: "Login", message: "User does not exist", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
            if let comerror = try? JSONDecoder().decode(cerror.self,from:data)
            {
                DispatchQueue.main.async {
             UIAlertView(title: "Login", message:comerror.message , delegate: nil, cancelButtonTitle: "OK").show()
                }
                self.activityIndicator.stopAnimating()
            }
            /*do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let code = json?["success"] as? Int
                if let code = code,code == 0
                {
                    let message = json?["message"] as? String
                    DispatchQueue.main.async{
                        UIAlertView(title: "Login", message: message!, delegate: nil, cancelButtonTitle: "OK").show()
                    }
                    
                    return
                }
                let creds = json?["data"] as? [[String:String]]
                if let creds = creds,creds.isEmpty
                {
                    
                    DispatchQueue.main.async
                        {
                            UIAlertView(title: "Login", message: "No such User", delegate: nil, cancelButtonTitle: "OK").show()
                            
                            self.activityIndicator.stopAnimating()
                    }
                    return
                }
                
                let pass = creds?[0]["pass"]
                DispatchQueue.main.async{
                    if pass != self.pass.text {
                        UIAlertView(title: "Login", message: "Wrong password", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                    else
                    {
                        UIAlertView(title: "Login", message: "Welcome", delegate: nil, cancelButtonTitle: "OK").show()
                        
                    }
                    self.activityIndicator.stopAnimating()
                    
                }
                
            }
            catch
            {
                
            }*/
            
            }.resume()
        
        
    }
    
}

