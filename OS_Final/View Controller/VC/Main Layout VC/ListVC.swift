//
//  ListVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import MJRefresh

class ListVC: NotificationVC {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_timeChange: UIView!
    @IBOutlet var view_writeIn: UIView!
    
    @IBOutlet var imageView_list: UIImageView! // 給予popover的邊界，沒有要做其他動作
    @IBOutlet var label_title: UILabel!
    @IBOutlet var label_totalCost: UILabel!
    
    private var selectedTimeTndex: Int = 0
    private var timeChangeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func componentsInit() {
        viewInit()
        tableViewInit()
        arrayInit()
    }
    
    private func viewInit() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view_gradient.bounds.size.height)
        view_gradient.layer.insertSublayer(gradient, at: 0)
        
        view_gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        setViewTap()
    }
    
    private func setViewTap() {
        view_timeChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeChangeDidTap)))
        view_writeIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writeInDidTap)))
    }
    
    private func tableViewInit() {
        tableView.register(UINib(nibName: "listDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "listHeader")
        tableView.register(UINib(nibName: "listTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        
        // iOS系統在15版以上會去預留空位給tableView header，所以要將預留空間去除
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
        }
        
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
    
    private func arrayInit() {
        timeChangeArr.append(contentsOf: locatedManager.array_time.map { $0 })
    }
    
    @objc private func timeChangeDidTap() {
        let popverVC = setPopover(isAutoLayout: false, cellLimit: timeChangeArr.count, width: Int(view_timeChange.bounds.width))
        popverVC.tableView.backgroundColor = UIColor.white_FFFFFF
        popverVC.tableView.delegate = self
        popverVC.tableView.dataSource = self
        popverVC.tableView.tag = 1
        
        if let popover = popverVC.popoverPresentationController {
            popover.delegate = self
            popover.sourceView = view_timeChange
            popover.sourceRect = CGRect(origin: CGPoint(x: 10, y: 0), size: imageView_list.frame.size)
        }
        present(popverVC, animated: true, completion: nil)
    }
    
    @objc private func writeInDidTap() {
        self.showNoticeDialogVC(title: .writeIn)
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 設定header個數
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 設定header高度
        return tableView.tag == 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 設定header內容
        switch tableView.tag {
        case 0:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "listHeader") as? listDetailHeaderView else { return listDetailHeaderView() }
            return header
        case 1:
            let header = UIView()
            header.backgroundColor = UIColor.clear
            return header
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 設定rows個數
        return tableView.tag == 0 ? 20 : timeChangeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 設定rows高度
        return 40
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 設定rows內容
        switch tableView.tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? listTableViewCell else { return listTableViewCell() }
            cell.setCell(date: "\(indexPath.row)", img: "", cost: "", detail: "")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            guard let detail: String = timeChangeArr.getObject(at: indexPath.row) else { return cell }
            
            cell.backgroundColor = UIColor.white_FFFFFF
            
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = detail
                content.textProperties.color = UIColor.black
                content.textProperties.font = UIFont.systemFont(ofSize: 20)
                content.textProperties.alignment = .center
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = detail
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                cell.textLabel?.textAlignment = .center
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0:
            self.showNoticeDialogVC(title: .list)
        case 1:
            if let detail = timeChangeArr.getObject(at: indexPath.row) {
                selectedTimeTndex = indexPath.row
                label_title.text = detail
                presentedViewController?.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension ListVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
