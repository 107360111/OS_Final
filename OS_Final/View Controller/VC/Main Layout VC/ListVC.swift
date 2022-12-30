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

@objc enum Symbols: Int {
    case ways = 1
    case time = 2
    case type = 3
    case cost = 4
}

class ListVC: NotificationVC {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_waysChange: UIView!
    @IBOutlet var view_timeChange_width: NSLayoutConstraint!
        
    @IBOutlet var imageView_list: UIImageView! // 給予popover的邊界，沒有要做其他動作
    @IBOutlet var label_title: UILabel!
    @IBOutlet var label_totalCost: UILabel!
    
    // MARK: -- List --
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var view_title_time: UIView! // 按鈕用
    @IBOutlet var view_title_type: UIView! // 按鈕用
    @IBOutlet var view_title_cost: UIView! // 按鈕用
    
    @IBOutlet var label_title_time: UILabel!
    @IBOutlet var label_title_type: UILabel! // 隱藏用
    @IBOutlet var label_title_cost: UILabel!
    
    @IBOutlet var view_imageView_type_symbol: UIView! // 隱藏用
    
    @IBOutlet var label_time_symbol: UILabel! // 顯示用
    @IBOutlet var imageView_type_symbol: UIImageView! // 顯示用
    @IBOutlet var label_cost_symbol: UILabel! // 顯示用
    
    // MARK: -- DataArr --
    private var listDataTableArr: Results<noteData>? { didSet { tableView.reloadData()
        let cost: Int = UserDefaultManager.getTotalCost(costWay: .payIn) - UserDefaultManager.getTotalCost(costWay: .payOut)
        if cost > 0 { // 收入 > 支出
            self.label_totalCost.textColor = UIColor.green_1CBF47
        } else if cost < 0 { // 收入 < 支出
            self.label_totalCost.textColor = UIColor.red_FF2C5B
        } else { // 收入 = 支出
            self.label_totalCost.textColor = UIColor.black
        }
        self.label_totalCost.text = String(format: "%2d", abs(Int(cost)))
    }}
    
    private let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    private var waysChangeArr = [String]()
    private var timeChangeArr = [String]()
    private var typeChangeArr = [String]()
    private var costChangeArr = [String]()
    
    private var chooseIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label_totalCost.text = String(format: "%2d", UserDefaultManager.getTotalCost(costWay: .payIn) - UserDefaultManager.getTotalCost(costWay: .payOut))
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
        stackViewInit()
        tableViewInit()
        arrayInit()
    }
    
    private func viewInit() {
        setGradientBackgroundColor(view: view_gradient)
        
        view_timeChange_width.constant = isPad ? 250 : AppWidth / 2
        setViewTap()
    }
    
    private func setViewTap() {
        view_waysChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(waysChangeDidTap)))
        view_title_time.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeChangeDidTap)))
        view_title_type.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeChangeDidTap)))
        view_title_cost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(costChangeDidTap)))
    }
    
    private func stackViewInit() {
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.layer.cornerRadius = 10
    }
    
    private func tableViewInit() {
        tableView.register(UINib(nibName: "listTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        
        // iOS系統在15版以上會去預留空位給tableView header，所以要將預留空間去除
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
        }
    }
    
    private func arrayInit() {
        waysChangeArr.append(contentsOf: locatedManager.array_ways.map { $0 })
        timeChangeArr.append(contentsOf: locatedManager.array_timeCompare.map { $0 })
        typeChangeArr.append(contentsOf: locatedManager.array_allItems.map { $0 })
        costChangeArr.append(contentsOf: locatedManager.array_costCompare.map { $0 })
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataList), name: NSNotification.Name("SendData"), object: nil)
    }
    
    private func setPopupView(symbol: Symbols) {
        
        var array = [String]()
        var popupView_width = Int()
        var sourceView = UIView()
        var size = CGSize()
        
        switch symbol {
        case .ways:
            array = waysChangeArr
            popupView_width = Int(view_timeChange_width.constant)
            sourceView = view_waysChange
            size = imageView_list.frame.size
        case .time:
            array = timeChangeArr
            popupView_width = Int(view_title_time.frame.width)
            sourceView = view_title_time
            size = view_title_time.frame.size
        case .type:
            array = typeChangeArr
            popupView_width = Int(view_title_type.frame.width)
            sourceView = view_title_type
            size = view_title_type.frame.size
        case .cost:
            array = costChangeArr
            popupView_width = Int(view_title_cost.frame.width)
            sourceView = view_title_cost
            size = view_title_cost.frame.size
        }
        
        var popverVC = setPopover(isAutoLayout: false, cellLimit: array.count > 5 ? 5 : array.count, width: popupView_width)
        
        popverVC.tableView.backgroundColor = UIColor.white_FFFFFF
        popverVC.tableView.delegate = self
        popverVC.tableView.dataSource = self
        popverVC.tableView.tag = symbol.rawValue
        
        if let popover = popverVC.popoverPresentationController {
            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = CGRect(origin: CGPoint(x: 10, y: 0), size: size)
        }
        present(popverVC, animated: true, completion: nil)
    }
    
    @objc private func handleDataList() {
        if let res = RealmManager.getData() {
            listDataTableArr = res
        }
    }
    
    @objc private func waysChangeDidTap() {
        setPopupView(symbol: .ways)
    }
    
    @objc private func timeChangeDidTap() {
        setPopupView(symbol: .time)
    }
    
    @objc private func typeChangeDidTap() {
        setPopupView(symbol: .type)
    }
    
    @objc private func costChangeDidTap() {
        setPopupView(symbol: .cost)
    }
}

extension ListVC: FixDataDialogVCDelegate {
    func chooseDelete() {
        let deleteDataType: String = listDataTableArr?[chooseIndex].type ?? ""
        let deleteDataCost: Int = listDataTableArr?[chooseIndex].cost ?? 0
        
        RealmManager.deleteData(data: listDataTableArr?[chooseIndex] ?? noteData())
        
        UserDefaultManager.setCost(cost: deleteDataCost, type: deleteDataType, costType: .delete)
        
        self.view.makeToast(ToastMes.ToastString(title: .canDelete), duration: LongTime)
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
        // 這邊設定40是為了不要讓第一筆資料跑版
        return tableView.tag == 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 設定rows個數
        switch tableView.tag {
        case 0:
            return listDataTableArr?.count ?? 0
        case 1:
            return waysChangeArr.count
        case 2:
            return timeChangeArr.count
        case 3:
            return typeChangeArr.count
        case 4:
            return costChangeArr.count
        default:
            return Int()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 設定rows高度
        return tableView.tag == 0 ? 60 : 42
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var array = [String]()
            
            switch tableView.tag {
            case 1:
                array = waysChangeArr
            case 2:
                array = timeChangeArr
            case 3:
                array = typeChangeArr
            case 4:
                array = costChangeArr
            default:
                array = [String]()
            }
            
            guard let detail: String = array.getObject(at: indexPath.row) else { return cell }
            
            cell.backgroundColor = UIColor.white_FFFFFF
            
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = detail
                content.textProperties.color = UIColor.black
                content.textProperties.font = UIFont.systemFont(ofSize: tableView.tag == 1 ? 20 : AppWidth < 350 ? 13 : 18)
                content.textProperties.alignment = .center
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = detail
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.font = UIFont.systemFont(ofSize: tableView.tag == 1 ? 20 : AppWidth < 350 ? 13 : 18)
                cell.textLabel?.textAlignment = .center
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0:
            chooseIndex = indexPath.row
            self.showFixDataDialogVC(title: .list, data: listDataTableArr?[indexPath.row] ?? noteData())
        case 1: // 選支出收入
            if let detail = waysChangeArr.getObject(at: indexPath.row) {
                label_title.text = detail
                var cost: Int = 0
                switch (indexPath.row) {
                case 0:
                    cost = UserDefaultManager.getTotalCost(costWay: .payIn) - UserDefaultManager.getTotalCost(costWay: .payOut)
                    self.label_totalCost.text = String(format: "%2d", abs(Int32(cost)))
                    self.label_totalCost.textColor = cost > 0 ? UIColor.green_59D945 : cost < 0 ? UIColor.red_E64646 : UIColor.black
                    break
                case 1:
                    cost = UserDefaultManager.getTotalCost(costWay: .payOut)
                    self.label_totalCost.text = String(format: "-%2d", cost)
                    self.label_totalCost.textColor = UIColor.black
                    break
                case 2:
                    cost = UserDefaultManager.getTotalCost(costWay: .payIn)
                    self.label_totalCost.text = String(format: "+%2d", cost)
                    self.label_totalCost.textColor = UIColor.black
                    break
                default:
                    break
                }
                presentedViewController?.dismiss(animated: true, completion: nil)
            }
            break
        case 2: // 選日期
            break
        case 3: // 選型別
            break
        case 4: // 選金額
            break
        default:
            presentedViewController?.dismiss(animated: true, completion: nil)
            break
        }
    }
}

extension ListVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
