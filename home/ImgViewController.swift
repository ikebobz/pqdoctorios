//
//  ImgViewController.swift
//  pqdoctor
//
//  Created by mac on 10/9/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
extension UIImageView
{
    func load(url:URL)
    {
        DispatchQueue.global().async{
            [weak self ] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }//implement image saving here
                    /*if let data = image.pngData(){
                        let filename = self?.editUrl(source: url.absoluteString)
                        try? data.write(to:filename!)*/
                
                }
            }
        }
    }
    func editUrl(source:String) -> URL
    {
        var edited:URL
        let srcurl = URL(string: source)
        edited = getDocumentsDirectory().appendingPathComponent(srcurl!.lastPathComponent)
        return edited
    }
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func loadFromDevice(path:String)
    {
        
    }
}


class ImgViewController: UIViewController {
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var imageurl = ""
    var figureLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if imageurl.contains("http"){
        imageView.load(url: URL(string: imageurl)!)
        }
        else
        {
            let copy = imageurl
            let fmanager = FileManager.default
            if fmanager.fileExists(atPath: imageurl){
         imageView.image = UIImage(contentsOfFile: imageurl)
            }
            else
            {
                UIAlertView(title: "Notice", message: "File doesn't exist", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        imageLabel.text = figureLabel
        // Do any additional setup after loading the view.
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
