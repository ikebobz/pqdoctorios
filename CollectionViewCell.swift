//
//  CollectionViewCell.swift
//  pqdoctor
//
//  Created by mac on 9/21/20.
//  Copyright © 2020 ikenna. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var txtLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtLabel.preferredMaxLayoutWidth = 500
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.leftAnchor.constraint(equalTo: leftAnchor),contentView.rightAnchor.constraint(equalTo: rightAnchor),contentView.topAnchor.constraint(equalTo: topAnchor),contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    @IBOutlet private var maxWidthConstraint:NSLayoutConstraint!{
        didSet{
            maxWidthConstraint.isActive = false
        }
    }
    var maxWidth:CGFloat? = nil {
        didSet{
            guard let maxWidth = maxWidth else{ return }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
}
