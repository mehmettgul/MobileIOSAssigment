//
//  ListViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import Alamofire

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ListItemCollectionViewCellDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var listData: [dataResponse] = []
    let baseUrl = "https://pixabay.com/api/"
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // her bir item'ın boyutunu belirlediğimiz fonksiyon.
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 60) / 2 // Hücreler arasındaki boşluğu da hesaba katarak genişlik hesabı
        let cellHeight: CGFloat = 210
            
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // kaç section olacağıyla alakalı method
        return listData.count // kaç eleman olacağını döndürür.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = listData[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listItem", for: indexPath) as? ListItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.getWidthHeightListItem(width: item.previewWidth, height: item.previewHeight)
        if let imageURL = URL(string: item.previewURL) {
            cell.imageView.kf.setImage(with: imageURL)
        }
        cell.delegate = self // ListItemCollectionViewCellDelegate protocolu'ünü kullanabilmek için kullanılır.
        cell.comments.text = "(\(item.comments) Yorum)"
        cell.likes.text = String(item.likes)
        cell.views.text = "\(item.views) (görüntülenme)"
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            listData.removeAll() // Mevcut verileri temizleyin.
            fetchData(with: query)
            searchBar.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listCollectionView.delegate = self 
        listCollectionView.dataSource = self
        searchBar.delegate = self
        
        listCollectionView.register(UINib(nibName: "ListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listItem") // Burası hazırladığımız cell tasarımını collectiona tanıtır.
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        listCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func didTapButtonInCell(_ cell: UICollectionViewCell) {
        guard let indexPath = listCollectionView.indexPath(for: cell) else {
            return
        }
        let selectedItem = listData[indexPath.row]
        LikeDataManager.shared.addLikesIfNotExists(data: selectedItem)
    }
    
    func fetchData(with query: String) {
        let _: [String: Any] = [
            "key": "37427312-d8d1e5548011abcd225706ea7",
            "q": query // Bu, q parametresiyle arama sorgusunu belirlemek için eklenir.
        ]
        
        AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7&q=\(query)", method: .get).responseJSON { response in
            if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
                print(error)
            } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
                do {
                    if let data = response.data {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // JSON verisi başarıyla parse edildi, verilere eriş
                            if let fetchData = json["hits"] as? [[String: Any]] {
                                    for data in fetchData { // her bir nesnenin doğru türden olup olmadığını kontrol ediyor.
                                    if  let id = data["id"] as? Int,
                                        let previewURL = data["previewURL"] as? String,
                                        let previewWidth = data["previewWidth"] as? Int,
                                        let previewHeight = data["previewHeight"] as? Int,
                                        let likes = data["likes"] as? Int,
                                        let comments = data["comments"] as? Int,
                                        let views = data["views"] as? Int,
                                        let user = data["user"] as? String,
                                        let userImageURL = data["userImageURL"] as? String,
                                        let webformatURL = data["webformatURL"] as? String,
                                        let webformatWidth = data["webformatWidth"] as? Int,
                                        let webformatHeight = data["webformatHeight"] as? Int {
                                        let responseData = dataResponse(id: id, previewURL: previewURL, previewWidth: previewWidth, previewHeight: previewHeight, likes: likes, comments: comments, views: views, user: user, userImageURL: userImageURL, webformatURL: webformatURL, webformatWidth: webformatWidth, webformatHeight: webformatHeight)
                                        self.listData.append(responseData)
                                    }
                                }
                            }
                        } else {
                            print("else'deki error")
                        }
                    }
                } catch {
                    print("catch'deki error")
                }
                self.listCollectionView.reloadData()
            }
        }
    }
    
}
