//
//  BusinessCell.swift
//  Yelp
//
//  Created by Chris Beale on 4/21/15.
//  Copyright (c) 2015 Chris Beale. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var business: Business? {
        didSet {
            if let business = business {
                if let imageUrl = business.imageUrl {
                    thumbImageView.setImageWithURL(NSURL(string: imageUrl))
                }
                ratingImageView.setImageWithURL(NSURL(string: business.ratingImageUrl!))
                nameLabel.text = business.name
                reviewCountLabel.text = "\(business.numberOfReviews!)"
                addressLabel.text = business.address
                categoryLabel.text = business.categories
                distanceLabel.text =  String(format:"%.2f", business.distance!) + " km"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Assuming 2 labels with dynamic height in my cell: myLabelA and myLabelB
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

}
