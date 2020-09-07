//
//  hViewController.swift
//  pqdoctor
//
//  Created by mac on 8/8/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit

class hViewController: UIViewController {

    @IBOutlet weak var passw: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var names: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    struct reply:Codable
    {
    let success:Int
    let message:String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func _newUser(_ sender: Any) {
        activityIndicator.startAnimating()
        let url = URL(string: "http://192.168.178.44:8012/pqsolutions_webpart/addEntry.php")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = "names=\(names.text!)&email=\(email.text!)&pass=\(passw.text!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request,completionHandler:{
        (data,response,error) in
            if
                (error != nil){
                DispatchQueue.main.async {
                    UIAlertView(title: "Feedback", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
                    self.activityIndicator.stopAnimating()
                    
                }
            } else {
                let fromServer = try? JSONDecoder().decode(reply.self,from:data!)
                DispatchQueue.main.async {
                    UIAlertView(title: "Feedback", message:fromServer?.message, delegate: nil, cancelButtonTitle: "OK").show()
                    self.activityIndicator.stopAnimating()
                    
                }            }
            })
        task.resume()
        
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
