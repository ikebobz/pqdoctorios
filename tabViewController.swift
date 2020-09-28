//
//  tabViewController.swift
//  pqdoctor
//
//  Created by mac on 9/20/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
extension UILabel
{
    class func textWidth(font:UIFont,text:String) -> CGFloat
    {
        let mytext = text as NSString
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = mytext.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil)
        return ceil(labelSize.width)
    }
    class func textWidth(label:UILabel,text:String) -> CGFloat
    {
       return textWidth(font: label.font, text: text)
    }
    class func textWidth(label:UILabel) -> CGFloat
    {
        return textWidth(label: label, text: label.text!)
    }
    func textWidth() -> CGFloat
    {
        return UILabel.textWidth(label:self)
    }
    
}

private let reuseIdentifier = "cell"
class tabViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    {
        didSet {
            //collectionLayout.itemSize = CGSize(width: 150, height: 50)
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var headers = [String]()
    var item = [[[String]]]()
    var items = [["january","february","march"],["cat","dog","parrot"],["mars","mercury","venus"],["london","DC","berlin"]]
    var indx = 0

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number =  item[indx][section].count
        return number
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.maxWidth = collectionView.frame.width
        let i = indexPath.section
        let j = indexPath.item
        let word = item[indx][i][j]
        cell.txtLabel?.text = word
        //cell.backgroundColor = UIColor.green
        return cell
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
      let number =  item[indx].count
      return number
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        let size = headers.count
        if indx >= size - 1 {indx = 0} else {indx = indx + 1}
        self.tableLabel?.text = headers[indx]
        self.mCollectionView.reloadData()
    }
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        self.tableLabel?.text = headers[indx]
        if headers.count > 1
        {
          /*btnNext.backgroundColor = UIColor.cyan
          btnNext.setTitleColor(UIColor.white, for: .normal)*/
            btnNext.isEnabled = true
        }
        else {btnNext.isEnabled = false}
        //self.mCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mCollectionView.delaysContentTouches = true
        self.mScrollView.contentSize = CGSize(width:self.mCollectionView.frame.width,height:self.mCollectionView.frame.height + 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       //return CGSize(width: 150, height: 30)
        //let text = item[indx][indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let width = maxSize(section: item[indx][indexPath.section], font: (cell.txtLabel?.font)!)
        return CGSize(width: width + 20, height: 50) 
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func maxSize(section:[String],font:UIFont) -> CGFloat
    {
        var max = 0
        for item in section
        {
        let width = UILabel.textWidth(font: font, text: item)
        if Int(width) > max
        {
         max = Int(width)
        }
        }
        return CGFloat(max)
    }

}
