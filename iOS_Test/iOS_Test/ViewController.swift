//
//  ViewController.swift
//  iOS_Test
//
//  Created by Aang on 31/07/24.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var imgCollectionView: UICollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var flotingBtn: UIButton!
    
    
    let imgArr = ["nature1", "nature2", "nature3", "nature4", "nature5"]
    
    var fruitTableArr = [
        fruit(name: "Lemon", subTitle: "Tangy and refreshing.", imgName: "lemon"),
        fruit(name: "Cherry", subTitle: "Sweet and juicy.", imgName: "cherry"),
        fruit(name: "Apple", subTitle: "Crisp and versatile.", imgName: "apple"),
        fruit(name: "Pomegranate", subTitle: "Rich and antioxidant-rich.", imgName: "pomegranate"),
        fruit(name: "Litchi", subTitle: "Sweet and floral.", imgName: "litchi"),
        fruit(name: "Strawberry", subTitle: "Sweet and juicy.", imgName: "strawberry"),
        fruit(name: "Orange", subTitle: "Fresh and tangy.", imgName: "orange"),
        fruit(name: "Banana", subTitle: "Sweet and creamy.", imgName: "banana"),
        fruit(name: "Watermelon", subTitle: "Hydrating and refreshing.", imgName: "watermelon"),
        fruit(name: "Pineapple", subTitle: "Tropical and tangy.", imgName: "pineapple")
    ]

    
    //for autoscroll collectionview
    var timer: Timer?
    var currentPage = 0
    
    var filteredFruitTableArr: [fruit] = []

    var lastContentOffset: CGFloat = 0 // for search bar
    
    var statisticsText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageControl.numberOfPages = imgArr.count
        
        filteredFruitTableArr = fruitTableArr
        
        flotingBtn.addBorder(cornerRadius: flotingBtn.frame.size.height/2)
        flotingBtn.layer.shadowRadius = 10
        flotingBtn.layer.shadowOffset = .zero
        flotingBtn.layer.shadowOpacity = 0.5
        flotingBtn.layer.shadowColor = UIColor.black.cgColor
        
        // Add a tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAutoScrolling()
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func floatingBtnClicked(_ sender: UIButton) {
        
        let items = ["Lemon", "Cherry", "Apple", "Pomegranate", "Litchi", "Strawberry", "Orange", "Banana", "Watermelon", "Pineapple"]
        let statistics = calculateStatistics(from: items)
        
        var statisticsText = "List (\(statistics.itemCount) items)"
        for (char, count) in statistics.topCharacters {
            statisticsText += "\n\(char) = \(count)"
        }
        
        if let bottomSheetVC = storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            bottomSheetVC.statisticsText = statisticsText
            bottomSheetVC.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()] // Configure sizes
            }
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }
    
    func calculateStatistics(from items: [String]) -> (itemCount: Int, topCharacters: [(character: Character, count: Int)]) {
        var charFrequency = [Character: Int]()
        
        for item in items {
            for char in item.lowercased() {
                if char.isLetter { // Only count letters
                    charFrequency[char, default: 0] += 1
                }
            }
        }
        
        let sortedChars = charFrequency.sorted { $0.value > $1.value }
        let topChars = Array(sortedChars.prefix(3)).map { ($0.key, $0.value) }
        
        return (items.count, topChars)
    }
}

//MARK: - Auto Scroll
extension ViewController{
    func startAutoScrolling() {
        // Schedule the timer to fire every 4 seconds
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    
    
    func stopAutoScrolling() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollToNextImage() {
        DispatchQueue.main.async { [self] in
            
            let nextPage = (currentPage + 1) % imgArr.count
            currentPage = nextPage
            pageControl.currentPage = currentPage
            
            
            let contentOffset = CGPoint(x: nextPage * Int(imgCollectionView.frame.width), y: 0)
            imgCollectionView.setContentOffset(contentOffset, animated: true)
            
        }
        
    }
}

//MARK: - ScrollView Delegate method
extension ViewController{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrolling()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Update the current page when scrolling ends
        let visibleRect = CGRect(origin: imgCollectionView.contentOffset, size: imgCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = imgCollectionView.indexPathForItem(at: visiblePoint) {
            currentPage = indexPath.item
            pageControl.currentPage = currentPage
        }
        
        // Restart auto-scrolling
        startAutoScrolling()
    }
}

//MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgCell
        
        cell.img.image = UIImage(named: imgArr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 10, height: 350)
    }
    
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredFruitTableArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! fruitTableViewCell
        
        cell.img.image = UIImage(named: filteredFruitTableArr[indexPath.row].imgName)
        cell.titleLbl.text = filteredFruitTableArr[indexPath.row].name
        cell.subtitleLbl.text = filteredFruitTableArr[indexPath.row].subTitle
        
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate, UITextFieldDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFruitTableArr = fruitTableArr
        } else {
            filteredFruitTableArr = fruitTableArr.filter { fruit in
                fruit.name.lowercased().contains(searchText.lowercased())
            }
        }
        tblView.reloadData()
    }
}
