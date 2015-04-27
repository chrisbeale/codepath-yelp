//
//  RadioGroupCell.swift
//  Yelp
//
//  Created by Chris Beale on 4/22/15.
//  Copyright (c) 2015 Chris Beale. All rights reserved.
//

import UIKit

protocol SegmentedControlCellDelegate: class {
    func segmentedControlCell(segmentedControlCell: SegmentedControlCell, controlValueChanged value: Int)
}


class SegmentedControlCell: UITableViewCell {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    weak var delegate: SegmentedControlCellDelegate?

    @IBAction func onSegmentValueChanged(sender: AnyObject) {
        delegate?.segmentedControlCell(self, controlValueChanged: segmentedControl.selectedSegmentIndex)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
