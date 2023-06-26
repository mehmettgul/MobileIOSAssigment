//
//  HomeViewController.swift
//  MobileIOSAssigment
//
//  Created by Mehmet Gül on 15.06.2023.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let baseUrl = "https://pixabay.com/api/" // gidilen endpointler hep farklı olduğundan farklı olan yerleri ekleyip sabit kalan yeri baseUrl olarak belirledik.
    let jsonDecoder = JSONDecoder()
    var data: [dataResponse] = []
    var userName = ""
    var like = ""
    var comment = ""
    var userImage = UIImage()
    var webformatImage = UIImage()
    var webformatWidth = 0
    var webformatHeight = 0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // her bir item'ın sağdan soldan yukardan ve aşağıdan boşluklarını belirtir.
        return UIEdgeInsets(top: 1.0, left: 4.0, bottom: 1.0, right: 4.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0 // hücreler arasında 10 birim yatay boşluk
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // her bir item'ın boyutunu belirlediğimiz fonksiyon.
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:300)
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
        
        let item = data[indexPath.row]
        
        cell.getWidthHeightListItem(width: item.previewWidth, height: item.previewHeight) // resimlerin boyutlarını cell dosyasına yolluyoruz
        if let imageURL = URL(string: item.previewURL) { // cell'lerdeki image'ların çekilmesi.
            cell.imageView.kf.setImage(with: imageURL)
            
        }
        cell.comments.text = "(\(item.comments) Yorum)" // comments, like, görüntülenme bilgisi çekiliyor.
        cell.likes.text = String(item.likes)
        cell.views.text = "\(item.views) (görüntülenme)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        self.userName = item.user // segue öncesi bu sayfada çektiğimiz verileri bu sayfadaki değişkenlerde tutuyoruz.
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
        self.performSegue(withIdentifier: "homeToDetail", sender: self) //image a tıklanınca detay sayfasına yönlendirme.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetail" {
            let destinationVC = segue.destination as! DetailViewController // destination değerinden bir viewController gelir ama hangisinin geldiğini bilemez o yüzden vc ise ona göre cast edilir.
            destinationVC.userName = userName
            destinationVC.comment = comment
            destinationVC.like = like
            destinationVC.userImage = userImage
            destinationVC.webformatWidth = webformatWidth
            destinationVC.webformatHeight = webformatHeight
            destinationVC.webformatImage = webformatImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self // Öğren
        collectionView.dataSource = self // Öğren
        
        // Veri çekme isteği atılıyor.
        fetchData()
        
        collectionView.register(UINib(nibName: "ListItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listItem") // Burası hazırladığımız cell tasarımını collectiona tanıtır.
        
        let layout = UICollectionViewFlowLayout() // grid düzen oluşturmak için kullandığımız blok
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func fetchData() {
        AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7", method: .get).responseJSON { response in
                if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
                    print(error)
                } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
                    do {
                        if let data = response.data {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                // JSON verisi başarıyla parse edildi, verilere eriş
                                if let fetchData = json["hits"] as? [[String: Any]] {
                                    for data in fetchData {
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
                                            print("previewURL: \(previewURL), previewWidth: \(previewWidth), previewHeight: \(previewHeight), Likes: \(likes), Comments: \(comments), Views: \(views), User: \(user), UserImageURL: \(userImageURL), webformatURL: \(webformatURL), webformatWidth: \(webformatWidth), webformatHeight: \(webformatHeight), id: \(id)")
                                            let responseData = dataResponse(id: id, previewURL: previewURL, previewWidth: previewWidth, previewHeight: previewHeight, likes: likes, comments: comments, views: views, user: user, userImageURL: userImageURL, webformatURL: webformatURL, webformatWidth: webformatWidth, webformatHeight: webformatHeight)
                                            self.data.append(responseData)
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
                     self.collectionView.reloadData()
                    //print(response)
                }
            }
        
    }
    
}

/*
 // Veri çekme isteği atılıyor.
 AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7", method: .get).responseJSON { response in
         if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
             print(error)
         } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
             print(response)
         }
     }
*/
/*
 // Veri çekme isteği atılıyor.
 AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7", method: .get).responseJSON { response in
         if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
             print(error)
         } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
             if let url = URL(string: "https://pixabay.com/api/?key=37427312-d8d1e5548011abcd225706ea7") {
                 URLSession.shared.dataTask(with: url) { (data, response, error) in
                     if error == nil {
                         do {
                             self.response = try self.jsonDecoder.decode([dataResponse].self, from: data!)
                         }catch {
                             print("parse error")
                         }
                         DispatchQueue.main.async {
                             self.collectionView.reloadData()
                         }
                     }
                 }.resume()
               }
             //print(response)
         }
 }
*/
/* ÇALIŞAN GÜNCEL
 func fetchData() {
     AF.request("\(baseUrl)?key=37427312-d8d1e5548011abcd225706ea7", method: .get).responseJSON { response in
             if let error = response.error { // hata alıp almadığımızı kontrol ediyoruz.
                 print(error)
             } else { // hata yoksa çektiğimiz verileri konsoldan görebiliyoruz.
                 do {
                     if let data = response.data {
                         if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                             // JSON verisi başarıyla parse edildi, verilere erişmeye hazırsınız
                             
                             if let fetchData = json["hits"] as? [[String: Any]] {
                                 for data in fetchData {
                                     if let previewURL = data["previewURL"] as? String,
                                         let previewWidth = data["previewWidth"] as? Int,
                                         let previewHeight = data["previewHeight"] as? Int,
                                         let likes = data["likes"] as? Int,
                                         let comments = data["comments"] as? Int,
                                         let views = data["views"] as? Int {
                                         print("previewURL: \(previewURL), previewWidth: \(previewWidth), previewHeight: \(previewHeight), Likes: \(likes), Comments: \(comments), Views: \(views)")
                                     }
                                 }
                                 //self.data = fetchData
                             }
                         } else {
                             print("else'deki error")
                         }
                     }
                 } catch {
                     print("catch'deki error")
                 }
                 //print(response)
             }
         }
 }
*/