//
//  ViewController.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import Toast_Swift

class ViewController: NotificationVC {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    static var selectIndex: Int = 0
    
    private var barCount: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
        notificationInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientStatusBar()
                
        scroll(to: 1, animated: false)
    }
    
    private func collectionViewInit() {
        collectionView.register(UINib(nibName: "barCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "barCell")
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStopScrolling), name: NSNotification.Name("StopScrolling"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContinuneScrolling), name: NSNotification.Name("ContinuneScrolling"), object: nil)
    }
    
    private func setPageView(page: Int, animated: Bool) {
        if page == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseCamera"), object: nil)
        }
        ViewController.selectIndex = page
        setGradientStatusBar()
        UIView.setAnimationsEnabled(animated)
        
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
        }) { (_) in
            self.collectionView.reloadSections(IndexSet(integer: 0))
            UIView.setAnimationsEnabled(true)
        }
    }
    
    private func setCollectionBarColor() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: collectionView.bounds.size.height)
        collectionView.layer.insertSublayer(gradient, at: 0)
        
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    internal func scroll(to page: Int, animated: Bool) {
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(page) * AppWidth, y: 0), animated: animated)
            self.setPageView(page: page, animated: animated)
        }
    }
    
    @objc private func handleStopScrolling() {
        self.scrollView.isScrollEnabled = false
    }
    
    @objc private func handleContinuneScrolling() {
        self.scrollView.isScrollEnabled = true
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frameLayoutGuide.layoutFrame.size.width
        let currentPage: CGFloat = scrollView.contentOffset.x / pageWidth
        guard CGFloat(ViewController.selectIndex) != currentPage else { return }
        setPageView(page: Int(currentPage), animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "barCell", for: indexPath) as? barCollectionViewCell else { return barCollectionViewCell() }
        
        let isSelected: Bool = indexPath.row == ViewController.selectIndex
        var unreadCnt: Int = 0
        switch indexPath.row {
        case 0:
            unreadCnt = 0
        case 2:
            unreadCnt = 0
        default:
            unreadCnt = 0
        }
        cell.setCell(index: indexPath.row, isSelected: isSelected, unreadCnt: unreadCnt)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard ViewController.selectIndex != indexPath.row else { return }
        scroll(to: indexPath.row, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppWidth / CGFloat(barCount + 1), height: 50)
    }
}
