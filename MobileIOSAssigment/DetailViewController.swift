//
//  DetailViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 16.06.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView?
    @IBOutlet weak var detailLike: UILabel!
    @IBOutlet weak var detailComments: UILabel!
    @IBOutlet weak var detailUserImage: UIImageView!
    @IBOutlet weak var detailUserName: UILabel!
    
    var dataResponse: dataResponse?
    
    init(dataResponse: dataResponse?) {
            self.dataResponse = dataResponse
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserImage'ı yuvarlak hale getirdik.
        detailUserImage.layer.cornerRadius = detailUserImage.frame.size.height / 2 // User image'ın şeklini yuvarlak yaptığımız kısım
        detailUserImage.clipsToBounds = true
        detailUserImage.contentMode = .scaleAspectFill
        // Bilgilerimizi aldık.
        if let dataResponse = dataResponse {
            detailUserName.text = dataResponse.user
            detailLike.text = String(dataResponse.likes)
            detailComments.text = "(\(dataResponse.comments) Yorum)"//String(dataResponse.comments)
            detailUserImage?.kf.setImage(with: URL(string: dataResponse.userImageURL))
            detailImage?.kf.setImage(with: URL(string: dataResponse.previewURL))
            detailImage?.frame.size = CGSize(width: dataResponse.webformatWidth, height: dataResponse.webformatHeight)
        }
    }
        
}
