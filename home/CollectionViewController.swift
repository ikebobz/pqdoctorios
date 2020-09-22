//
//  CollectionViewController.swift
//  pqdoctor
//
//  Created by mac on 9/13/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit


private let reuseIdentifier = "cvwcell"

class CollectionViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var headers = [String]()
    //var raws = [[String]]()
    var items = [[[String]]]() /*[["january","february","march"],["cat","dog","parrot"],["mars","mercury","venus"],["london","DC","berlin"]]*/
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
        
    }
   func addButton()
   {
   let button = UIButton()
    button.setTitle("Next", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    self.view.addSubview(button)
    button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    button.widthAnchor.constraint(equalToConstant:100).isActive = true
    button.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items[0].count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items[0][section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        /*var colsize = 0
        var xindex = 0
        while colsize < items[0].count
        {
            let field = UILabel(frame:CGRect(x:xindex + 10,y:0,width:200,height:60))
            field.font = UIFont.systemFont(ofSize: 15)
            field.numberOfLines = 0
            field.text = items[indexPath.row][colsize]
            cell.contentView.addSubview(field)
            colsize = colsize + 1
            xindex = xindex + 100
        }*/
        
        //cell.txtLabel?.text = items[0][indexPath.section][indexPath.item]
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
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
