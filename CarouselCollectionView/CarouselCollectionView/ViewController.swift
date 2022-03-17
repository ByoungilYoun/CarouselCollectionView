//
//  ViewController.swift
//  CarouselCollectionView
//
//  Created by 윤병일 on 2022/03/17.
//

import UIKit

class ViewController: UIViewController {
  
  //MARK: - Properties
  
  private lazy var carouselCollectionView : UICollectionView = {
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    return collectionView
  }()
  
  private let colorData : [UIColor] = [.yellow, .blue, .red, .brown, .purple]
  
  private lazy var increasedColorData :  [UIColor] = {
    colorData + colorData + colorData
  }()
  
  private var originalColorDataCount : Int {
    colorData.count
  }

  private var scrollToEnd : Bool = false
  private var scrollToBegin : Bool = false
  
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    carouselCollectionView.scrollToItem(at: IndexPath(item: originalColorDataCount, section: 0), at: .centeredHorizontally, animated: false)
  }
  
  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .white
    view.addSubview(carouselCollectionView)
    
    carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        carouselCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        carouselCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        carouselCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        carouselCollectionView.heightAnchor.constraint(equalToConstant: 400)
    ])
  }
}

  //MARK: - UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: view.bounds.width, height: 400)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return .zero
  }
}
  
  //MARK: - UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return increasedColorData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = increasedColorData[indexPath.item]
    return cell
  }
}

  //MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      
        let beginOffset = carouselCollectionView.frame.width * CGFloat(originalColorDataCount) // 15개 중에서 5번째 실제 데이터가 있는곳
        let endOffset = carouselCollectionView.frame.width * CGFloat(originalColorDataCount * 2 - 1) // 15개 중에서 10번째 실제 데이터가 있는곳
        
        if scrollView.contentOffset.x < beginOffset && velocity.x < .zero { // 처음 -> 마지막으로 드래그 했을때
            scrollToEnd = true
        } else if scrollView.contentOffset.x > endOffset && velocity.x > .zero { // 마지막 -> 처음으로 드래그 했을때
            scrollToBegin = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollToBegin {
            carouselCollectionView.scrollToItem(at: IndexPath(item: originalColorDataCount, section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToBegin.toggle()
            return
        }
      
        if scrollToEnd {
            carouselCollectionView.scrollToItem(at: IndexPath(item: originalColorDataCount * 2 - 1 , section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToEnd.toggle()
            return
        }
    }
}
