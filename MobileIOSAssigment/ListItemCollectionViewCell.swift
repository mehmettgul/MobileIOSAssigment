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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.isUserInteractionEnabled = true // image'a tıklama özelliği verdik.
        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToDetail)) // GR oluşuturulup aksiyon verildi. self'in nedeni fonksiyonun burda olması
//        imageView.addGestureRecognizer(gestureRecognizer) // view ' a GR eklendi
        
    }

    @IBAction func likeClicked(_ sender: Any) {
        print("tapped")
    }
    
    @objc func tapToDetail() { // Detay sayfasına gideceğimiz fonksiyon.
        print("tapToDetail")
        topToDetailButtonClicked?() // topToDetailButtonClicked bu fonksiyonu çağırır eğer fonk yoksa hata vermez.
    }
    var topToDetailButtonClicked : (()->())? // parametre de yok geri dönüş de yok. bu fonk çağrıldığında closure çağrılır.  Closure ise belli bir eylem için vs kullanılabilir. topToDetailButtonClicked değişkenine bir closure atadık, bu buton tıklandığında detay sayfasına gidilir. Closure'ı atadıktan sonra topToDetailButtonClicked?() ifadesiyle bu closure çağırılır.
    
    func getWidthHeightListItem(width: Int, height: Int) { // resimlerin boyutlarını alıp bu boyutlara göre gösterme işlemi yapıyoruz. 
        self.width = width
        self.height = height
    }
    
}
