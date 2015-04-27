//
//  FilterCell.swift
//  Yelp
//
//  Created by Chris Beale on 4/22/15.
//  Copyright (c) 2015 Chris Beale. All rights reserved.
//

import UIKit

protocol FilterCellDelegate: class {
    func filterCell(filterCell: FilterCell, switchValueChanged value: Bool)
}

class FilterCell: UITableViewCell {
    
    weak var delegate: FilterCellDelegate?

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.filterCell(self, switchValueChanged: filterSwitch.on)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
