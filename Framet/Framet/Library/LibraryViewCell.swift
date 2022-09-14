//
//  LibraryViewCell.swift
//  Framet
//
//  Created by Artem Paskevichyan on 13.12.2021.
//

import UIKit

class LibraryViewCell: UICollectionViewCell {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    
    static let baseIdentifire = "mainCell"
    static var imageSize: CGSize {
        CGSize(width: 450, height: 450)
    }
    
    var model: Album? {
        didSet {
            title.text = model?.title
            countLabel.text = String(model?.countLabel ?? 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        previewImage.layer.cornerRadius = 6
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LibraryViewCell", bundle: nil)
    }

}
