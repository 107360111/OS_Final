//
//  ListVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import MJRefresh

class ListVC: NotificationVC {
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func componentsInit() {
        viewInit()
        tableViewInit()
    }
    
    private func viewInit() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view_gradient.bounds.size.height)
        view_gradient.layer.insertSublayer(gradient, at: 0)
        
        view_gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    private func tableViewInit() {
        tableView.register(UINib(nibName: "listTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableView.reloadData()
        })
        
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("放開更新", for: .pulling)
        header.setTitle("正在更新", for: .refreshing)
        
        tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.tableView.reloadData()
        })
        
        footer.setTitle("上拉加載", for: .idle)
        footer.setTitle("放開加載", for: .pulling)
        footer.setTitle("正在加載", for: .refreshing)
        footer.setTitle("沒有資料了", for: .noMoreData)
        
        tableView.mj_footer = footer
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        return cell
    }
    
}
