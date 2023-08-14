//
//  HomeViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ListItemCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let baseUrl = "https://pixabay.com/api/" // gidilen endpointler hep farklı olduğundan farklı olan yerleri ekleyip sabit kalan yeri baseUrl olarak belirledik.
    let jsonDecoder = JSONDecoder()
    var data: [DataResponse] = []
    var userName = ""
    var like = ""
    var comment = ""
    var userImage = UIImage()
    var webformatImage = UIImage()
    var webformatWidth = 0
    var webformatHeight = 0
    var id = 0
    var index = -1
    var viewmodel = HomeViewmodel()
    var likeviewmodel = LikeViewmodel()
    var likedataviewmodel = LikeDataViewmodel()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // her bir item'ın sağdan soldan yukardan ve aşağıdan boşluklarını belirtir.
        return UIEdgeInsets(top: 1.0, left: 20.0, bottom: 1.0, right: 5.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0 // hücreler arasında 10 birim yatay boşluk
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // İtemlerın boyutlarının belirlendiği kısım. 
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // kaç section olacağıyla alakalı method
        return data.count // kaç eleman olacağını döndürür.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell'lerin içerisindeki verileri göstermeye yarayan method
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listItem", for: indexPath) as? ListItemCollectionViewCell else { return UICollectionViewCell() }
            // guard ve if aynı guard hatayı başta yakalar.
            // dequeueReusableCell bunun amacı hücre yeniden kullanılabilir. hücre içindeki veriler silinse de değişse de yeniden aynı hücre kullanılabilir.
        let item = data[indexPath.row] // diziden elemanları çekiyorum.
        cell.tag = indexPath.row // cell'in index değerini tutuyorum.
        let isLiked = likeviewmodel.isLiked(data: item)
        cell.isLiked = isLiked
        cell.delegate = self
        cell.getWidthHeightListItem(width: item.previewWidth, height: item.previewHeight) // resimlerin boyutlarını cell dosyasına yolluyoruz
        if let imageURL = URL(string: item.previewURL) { // cell'lerdeki image'ların çekilmesi.
            cell.imageView.kf.setImage(with: imageURL)
            
        }
        cell.comments.text = " (\(item.comments) Yorum)" // comments, like, görüntülenme bilgisi çekiliyor.
        cell.likes.text = String(item.likes)
        cell.views.text = "\(item.views) (görüntülenme)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        let item = data[indexPath.row]
        self.id = item.id
        self.userName = item.user
        self.like = String(item.likes)
        self.comment = "(\(item.comments) Yorum)"
        if let userImageURL = URL(string: item.userImageURL) { // userImage çek
            KingfisherManager.shared.retrieveImage(with: userImageURL) { result in
                switch result {
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        self.userImage = imageResult.image
                    }
                case .failure(let error):
                    print("User image retrieval error: \(error.localizedDescription)")
                }
            }
        }
        if let webformatURL = URL(string: item.webformatURL) { // büyük resmi çek.
            KingfisherManager.shared.retrieveImage(with: webformatURL) { result in // resmi indirip önbelleğe alır.
                switch result {
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        self.webformatImage = imageResult.image
                    }
                case .failure(let error):
                    print("Webformat image retrieval error: \(error.localizedDescription)")
                }
            }
        }
        self.webformatWidth = item.webformatWidth
        self.webformatHeight = item.webformatHeight
        // Programatik View Controller Geçişi : 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            let selectedData = data[indexPath.row]
            vc.dataResponse = selectedData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func homeDataUpload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self	
        
        // Veri çekme isteği atılıyor.
        viewmodel.fetchData { data in
            self.data = data
            self.collectionView.reloadData()
        }
        collectionView.register(UINib(nibName: "ListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listItem") // Burası hazırladığımız cell tasarımını collectiona tanıtır.
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20 // Hücreler arasındaki boşluk
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Hücreler ile ekran arasındaki boşluk
        collectionView.setCollectionViewLayout(layout, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(homeDataUpload), name: NSNotification.Name("homeDataUpload"), object: nil)
    }
    
    func didTapButtonInCell(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let selectedItem = data[indexPath.row]
        likeviewmodel.toggleLike(data: selectedItem)
    }
    
}
