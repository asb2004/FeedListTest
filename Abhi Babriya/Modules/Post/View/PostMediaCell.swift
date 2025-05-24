//
//  PostMediaCell.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import UIKit

class PostMediaCell: UICollectionViewCell {

    @IBOutlet weak var imgPost: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imgPost.image = nil
    }

}
