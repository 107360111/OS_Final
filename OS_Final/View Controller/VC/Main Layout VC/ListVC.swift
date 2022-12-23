//
//  ListVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import MJRefresh
import Toast_Swift
import RealmSwift

class ListVC: NotificationVC {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_timeChange: UIView!
    @IBOutlet var view_timeChange_width: NSLayoutConstraint!

    @IBOutlet var imageView_list: UIImageView! // 給予popover的邊界，沒有要做其他動作
    @IBOutlet var label_title: UILabel!
    @IBOutlet var label_totalCost: UILabel!
    
    private var listDataTableArr: Results<noteData>? { didSet { tableView.reloadData()
        let cost: Int = UserDefaultManager.getTotalCost()
        if cost > 0 {
            self.label_totalCost.textColor = UIColor.green_1CBF47
        } else if cost < 0 {
            self.label_totalCost.textColor = UIColor.red_FF2C5B
        } else {
            self.label_totalCost.textColor = UIColor.black
        }
        self.label_totalCost.text = String(format: "%2d", abs(Int(cost)))
    }}
    
    private let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    private var waysChangeArr = [String]()
    private var chooseIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label_totalCost.text = String(format: "%2d", UserDefaultManager.getTotalCost())
        realmInit()
        componentsInit()
        notificationInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func realmInit() {
        if let res = RealmManager.getData() {
            listDataTableArr = res
        }
    }
    
    private func componentsInit() {
        viewInit()
        tableViewInit()
        arrayInit()
    }
    
    private func viewInit() {
        setGradientBackgroundColor(view: view_gradient)
        
        view_timeChange_width.constant = isPad ? 250 : AppWidth / 2
        setViewTap()
    }
    
    private func setViewTap() {
        view_timeChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeChangeDidTap)))
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
        waysChangeArr.append(contentsOf: locatedManager.array_time.map { $0 })
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataList), name: NSNotification.Name("SendData"), object: nil)
    }
    
    @objc private func handleDataList() {
        if let res = RealmManager.getData() {
            listDataTableArr = res
        }
    }
    
    @objc private func timeChangeDidTap() {
        let popverVC = setPopover(isAutoLayout: false, cellLimit: waysChangeArr.count, width: Int(view_timeChange_width.constant))
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
        self.showWriteInDialogVC()
    }
}

extension ListVC: FixDataDialogVCDelegate {
    func chooseDelete() {
        let deleteDataType: String = listDataTableArr?[chooseIndex].ways ?? ""
        let deleteDataCost: Int = listDataTableArr?[chooseIndex].cost ?? 0
        
        RealmManager.deleteData(data: listDataTableArr?[chooseIndex] ?? noteData())
        
        if locatedManager.array_payIn.filter({ $0.contains(deleteDataType) }).count > 0 {
            UserDefaultManager.setDeletePayInCost(cost: deleteDataCost)
        } else if locatedManager.array_payOut.filter({ $0.contains(deleteDataType) }).count > 0 {
            UserDefaultManager.setDeletePayOutCost(cost: deleteDataCost)
        }
        
        self.view.makeToast("已順利刪除", duration: 0.5)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendData"), object: nil)
    }
    
    func chooseFix() {
        let VC = WriteInVC(data: listDataTableArr?[chooseIndex] ?? noteData())
        self.navigationController?.pushViewController(VC, animated: true)
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
        return tableView.tag == 0 ? listDataTableArr?.count ?? 0 : waysChangeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 設定rows高度
        return tableView.tag == 0 ? 60 : 40
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 設定rows內容
        switch tableView.tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? listTableViewCell else { return listTableViewCell() }
            let row: Int = indexPath.row
            let date: String = listDataTableArr?[row].date ?? ""
            let img: String = listDataTableArr?[row].type ?? ""
            let cost: Int = listDataTableArr?[row].cost ?? 0
            cell.setCell(date: date, img: img, cost: cost)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            guard let detail: String = waysChangeArr.getObject(at: indexPath.row) else { return cell }
            
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
            chooseIndex = indexPath.row
            self.showFixDataDialogVC(title: .list, data: listDataTableArr?[indexPath.row] ?? noteData())
        case 1:
            if let detail = waysChangeArr.getObject(at: indexPath.row) {
                label_title.text = detail
                var cost: Int = 0
                switch (indexPath.row) {
                case 0:
                    cost = UserDefaultManager.getTotalCost()
                    self.label_totalCost.text = String(format: "%2d", abs(Int32(cost)))
                    self.label_totalCost.textColor = cost > 0 ? UIColor.green_59D945 : cost < 0 ? UIColor.red_E64646 : UIColor.black
                    break
                case 1:
                    cost = UserDefaultManager.getPayOutCost()
                    self.label_totalCost.text = String(format: "-%2d", cost)
                    self.label_totalCost.textColor = UIColor.black
                    break
                case 2:
                    cost = UserDefaultManager.getPayInCost()
                    self.label_totalCost.text = String(format: "+%2d", cost)
                    self.label_totalCost.textColor = UIColor.black
                    break
                default:
                    cost = 0
                }
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
