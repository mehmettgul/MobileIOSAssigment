//
//  DetailViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 16.06.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView?
    @IBOutlet weak var detailLike: UILabel!
    @IBOutlet weak var detailComments: UILabel!
    @IBOutlet weak var detailUserImage: UIImageView!
    @IBOutlet weak var detailUserName: UILabel!
    
    var userName = ""
    var like = ""
    var comment = ""
    var userImage = UIImage()
    var webformatImage = UIImage()
    var webformatWidth: Int = 0
    var webformatHeight: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserImage'ı yuvarlak hale getirdik.
        detailUserImage.layer.cornerRadius = detailUserImage.frame.size.height / 2 // User image'ın şeklini yuvarlak yaptığımız kısım
        detailUserImage.clipsToBounds = true
        detailUserImage.contentMode = .scaleAspectFill
        // Bilgilerimizi aldık.
        detailUserName.text = userName
        detailLike.text = like
        detailComments.text = comment
        detailUserImage.image = userImage
        detailImage?.image = webformatImage
        detailImage?.frame.size = CGSize(width: webformatWidth, height: webformatHeight)
        
    }
        
}
