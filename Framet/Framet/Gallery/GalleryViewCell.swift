//
//  GalleryViewCell.swift
//  Framet
//
//  Created by Artem Paskevichyan on 22.12.2021.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    static let baseIdentifier = "galleryCell"
    var imageSize: CGSize {
        CGSize(
            width: self.frame.width / 2,
            height: self.frame.width / 2
        )
    }
    
    var model: String?

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GalleryViewCell", bundle: nil)
    }

}
