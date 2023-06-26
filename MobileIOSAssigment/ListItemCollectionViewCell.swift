//
//  ListItemCollectionViewCell.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit

class ListItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var width: Int = 0
    var height: Int = 0
    var id = 0 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.isUserInteractionEnabled = true // image'a tıklama özelliği verdik.
        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToDetail)) // GR oluşuturulup aksiyon verildi. self'in nedeni fonksiyonun burda olması
//        imageView.addGestureRecognizer(gestureRecognizer) // view ' a GR eklendi
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.frame.size = CGSize(width: self.width, height: self.height)
    }

    @IBAction func likeClicked(_ sender: Any) {
        print("tapped")
    }
    
    @objc func tapToDetail() { // Detay sayfasına gideceğimiz fonksiyon.
        print("tapToDetail")
        topToDetailButtonClicked?() // Öğren
    }
    var topToDetailButtonClicked : (()->())? // Öğren
    
    func getWidthHeightListItem(width: Int, height: Int) { // resimlerin boyutlarını alıp bu boyutlara göre gösterme işlemi yapıyoruz. 
        self.width = width
        self.height = height
    }
    
}
