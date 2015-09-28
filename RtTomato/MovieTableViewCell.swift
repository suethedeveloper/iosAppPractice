//
//  MovieTableViewCell.swift
//  RtTomato
//
//  Created by Sue Lucas on 9/26/15.
//  Copyright © 2015 Sue Lucas. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDescriptionLabel: UILabel!
    
    var posterURL: NSURL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
