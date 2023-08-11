//
//  ListItemCollectionViewCell.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import CoreData

protocol ListItemCollectionViewCellDelegate: AnyObject {
    func didTapButtonInCell(_ cell: UICollectionViewCell)
}

class ListItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: ListItemCollectionViewCellDelegate?
    
    var width: Int = 0
    var height: Int = 0
    
    @IBAction func likeClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("homeDataUpload"), object: nil)
        delegate?.didTapButtonInCell(self)
    }    
    
    func getWidthHeightListItem(width: Int, height: Int) { // resimlerin boyutlarını alıp bu boyutlara göre gösterme işlemi yapıyoruz. 
        self.width = width
        self.height = height
    }
    
    var isLiked: Bool = false {
        didSet {
            // Like yapıldığında değişecek şeyler.
            let buttonImage = isLiked ? UIImage(named: "Like") : UIImage(named: "dislike")
            likeButton.setImage(buttonImage, for: .normal)
        }
    }
    
}
