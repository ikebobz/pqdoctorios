//
//  tabViewController.swift
//  pqdoctor
//
//  Created by mac on 9/20/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit
extension String
{
    
}

private let reuseIdentifier = "cell"
class tabViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
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
          btnNext.backgroundColor = UIColor.green
          btnNext.setTitleColor(UIColor.white, for: .normal)
        }
        //self.mCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    

}
