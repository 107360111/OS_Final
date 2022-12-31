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

@objc enum System: Int {
    case high2low = 0
    case low2high = 1
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
    private var listDataTableArr = [noteData]() { didSet { tableView.reloadData()
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
    
    private var chooseIndex: Int = 0
    
    private var waysChangeArr = [String]()
    private var timeChangeArr = [String]()
    private var typeChangeArr = [String]()
    private var costChangeArr = [String]()
    
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
            listDataTableArr = Array(res)
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
        
        let popverVC = setPopover(isAutoLayout: false, cellLimit: array.count > 5 ? 5 : array.count, width: popupView_width)
        
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
    
    private func resetList(symbol: Symbols, row: Int, changeType: String) {
        if let res = RealmManager.getData() {
            listDataTableArr = Array(res)
        }
        
        if changeType == "" { // 只有在選擇型別並且不是不限時才禁止方法的按鈕
            view_waysChange.isUserInteractionEnabled = true
            imageView_list.image = UIImage(named: "chooseTime")
        } else {
            view_waysChange.isUserInteractionEnabled = false
            imageView_list.image = UIImage(named: "unchooseTime")
        }
        
        switch symbol {
        case .ways:
            resetTotalCost(symbol: .ways, row: row)
            break
        case .time:
            if row == 1 {
                listDataTableArr = filterArray(array: listDataTableArr, symbol: symbol, changeType: "", sortType: "close2far")
            } else if row == 2 {
                listDataTableArr = filterArray(array: listDataTableArr, symbol: symbol, changeType: "", sortType: "far2close")
            }
            resetTotalCost(symbol: .time)
            break
        case .type:
            
            listDataTableArr = filterArray(array: listDataTableArr, symbol: symbol, changeType: changeType, sortType: "")
            
            if row != 0 {
                resetCostByTapType(changeType: changeType)
            } else {                
                resetTotalCost(symbol: .type)
            }
            break
        case .cost:
            if row == 1 {
                listDataTableArr = filterArray(array: listDataTableArr, symbol: symbol, changeType: "", sortType: "small2big")
            } else if row == 2 {
                listDataTableArr = filterArray(array: listDataTableArr, symbol: symbol, changeType: "", sortType: "big2small")
            }
            resetTotalCost(symbol: .cost)
            break
        }
    }
    
    private func filterArray(array: [noteData], symbol: Symbols, changeType: String, sortType: String) -> [noteData] {
        var new_array = [noteData]() // 新的匯出陣列
        var temp_array_cost = [Int]() // 紀錄cost暫存
        var temp_array_dateTimeStamp = [Int]() // 紀錄date轉換成時間戳的暫存
        
        var temp_array_id_key = [String]() // 紀錄id_key
        var sorted_temp_array_id_key = [String]() // 紀錄排序後id_key
        
        for idKey in 0..<array.count {
            temp_array_id_key.append(array[idKey].id_key)
        }
        
        switch symbol {
        case .ways:
            break
        case .time:
            for index in 0..<array.count {// 暫存時間戳資料
                temp_array_dateTimeStamp.append(DateManager.stringToNumber(String: array[index].date))
            }
            
            if sortType == "far2close" { // 由近排到遠
                (temp_array_dateTimeStamp, sorted_temp_array_id_key) = sorted(array: temp_array_dateTimeStamp, idKeyArray: temp_array_id_key, system: .low2high)
            } else if sortType == "close2far" { // 由遠排到近
                (temp_array_dateTimeStamp, sorted_temp_array_id_key) = sorted(array: temp_array_dateTimeStamp, idKeyArray: temp_array_id_key, system: .high2low)
            }
                        
            for sorted_id_key in sorted_temp_array_id_key {
                if let new_index = temp_array_id_key.firstIndex(of: sorted_id_key) {
                    new_array.append(array[new_index])
                }
            }
            break
        case .cost:
            for index in 0..<array.count { // 暫存金額資料
                temp_array_cost.append(array[index].cost)
            }
            
            if sortType == "small2big" { // 由小排到大
                (temp_array_cost, sorted_temp_array_id_key) = sorted(array: temp_array_cost, idKeyArray: temp_array_id_key, system: .low2high)
            } else if sortType == "big2small" { // 由大排到小
                (temp_array_cost, sorted_temp_array_id_key) = sorted(array: temp_array_cost, idKeyArray: temp_array_id_key, system: .high2low)
            }
            
            for sorted_id_key in sorted_temp_array_id_key {
                if let new_index = temp_array_id_key.firstIndex(of: sorted_id_key) {
                    new_array.append(array[new_index])
                }
            }
            break
        case .type:
            if changeType == "" {
                return array
            }
            
            for index in 0..<array.count {
                if changeType == array[index].type {
                    new_array.append(array[index])
                }
            }
            
            break
        }
        return new_array
    }
    
    private func sorted(array: [Int], idKeyArray: [String], system: System) -> (array: [Int], idKetArray: [String]) {
        var array = array
        var idKeyArray = idKeyArray
        switch system {
        case .high2low:
            for i in 0..<array.count {
                for j in i..<array.count {
                    if array[j] > array[i] {
                        let temp = array[j]
                        array[j] = array[i]
                        array[i] = temp
                        
                        let temp_idKey = idKeyArray[j]
                        idKeyArray[j] = idKeyArray[i]
                        idKeyArray[i] = temp_idKey
                    }
                }
            }
            return (array, idKeyArray)
        case .low2high:
            for i in 0..<array.count {
                for j in i..<array.count {
                    if array[j] < array[i] {
                        let temp = array[j]
                        array[j] = array[i]
                        array[i] = temp
                        
                        let temp_idKey = idKeyArray[j]
                        idKeyArray[j] = idKeyArray[i]
                        idKeyArray[i] = temp_idKey
                    }
                }
            }
            return (array, idKeyArray)
        }
    }
    
    private func resetTotalCost(symbol: Symbols, row: Int = 0) {
        var cost = 0
        var row = row
        /// 還原初始化
        self.label_title.text = row == 1 ? "總支出" : row == 2 ? "總收入" : "總和"
        
        
        /// 設定價錢
        if symbol == .ways {
            cost = row == 1 ? UserDefaultManager.getTotalCost(costWay: .payOut) : row == 2 ? UserDefaultManager.getTotalCost(costWay: .payIn) : UserDefaultManager.getTotalCost(costWay: .payIn) - UserDefaultManager.getTotalCost(costWay: .payOut)
        } else {
            if label_title.text == "總和" {
                row = 0
                cost = UserDefaultManager.getTotalCost(costWay: .payIn) - UserDefaultManager.getTotalCost(costWay: .payOut)
            } else if label_title.text == "總支出" {
                row = 1
                cost = UserDefaultManager.getTotalCost(costWay: .payOut)
            } else if label_title.text == "總收入" {
                row = 2
                cost = UserDefaultManager.getTotalCost(costWay: .payIn)
            }
        }

        /// 顯示價錢
        switch (row) {
        case 0: // 總和
            self.label_totalCost.text = String(format: "%2d", abs(cost))
            self.label_totalCost.textColor = cost > 0 ? UIColor.green_59D945 : cost < 0 ? UIColor.red_E64646 : UIColor.black
            break
        case 1: // 總支出
            self.label_totalCost.text = String(format: "-%2d", cost)
            self.label_totalCost.textColor = UIColor.black
            break
        case 2: // 總輸入
            self.label_totalCost.text = String(format: "+%2d", cost)
            self.label_totalCost.textColor = UIColor.black
            break
        default:
            break
        }
    }
    
    private func resetCostByTapType(changeType: String) {
        var cost = 0
        let index = locatedManager.array_allItemsURL.firstIndex(of: changeType)
        
        if changeType != "others" {
            cost = UserDefaultManager.showCost(type: changeType)
        } else {
            cost = UserDefaultManager.showCost(type: "others_payin") - UserDefaultManager.showCost(type: "others_payout")
        }
        
        self.label_title.text = "種類為『 \(typeChangeArr[index ?? 14]) 』的金額為"
        self.label_totalCost.text = String(format: "%2d", abs(cost))
        self.label_totalCost.textColor = changeType != "others" ? UIColor.black : cost > 0 ? UIColor.green_59D945 : cost < 0 ? UIColor.red_E64646 : UIColor.black
    }
    
    @objc private func handleDataList() {
        if let res = RealmManager.getData() {
            listDataTableArr = Array(res)
            
            label_title_type.isHidden = false
            view_imageView_type_symbol.isHidden = true
            
            label_time_symbol.text = "(-)"
            label_title_type.text = "型別"
            label_cost_symbol.text = "(-)"
            
            resetList(symbol: .ways, row: 0, changeType: "") // 還原初始狀態
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
        let deleteDataType: String = listDataTableArr[chooseIndex].type
        let deleteDataCost: Int = listDataTableArr[chooseIndex].cost
        
        RealmManager.deleteData(data: listDataTableArr[chooseIndex])
        
        UserDefaultManager.setCost(cost: deleteDataCost, type: deleteDataType, costType: .delete)
        
        self.view.makeToast(ToastMes.ToastString(title: .canDelete), duration: LongTime)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendData"), object: nil)
    }
    
    func chooseFix() {
        let VC = WriteInVC(data: listDataTableArr[chooseIndex])
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
            return listDataTableArr.count
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
            let date: String = listDataTableArr[row].date
            let img: String = listDataTableArr[row].type
            let cost: Int = listDataTableArr[row].cost
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
            self.showFixDataDialogVC(title: .list, data: listDataTableArr[indexPath.row])
        case 1: // 選支出收入
            if let detail = waysChangeArr.getObject(at: indexPath.row) {
                label_title.text = detail
                
                resetList(symbol: .ways, row: indexPath.row, changeType: "")
            }
            presentedViewController?.dismiss(animated: true, completion: nil)
            break
        case 2: // 選日期
            label_title_type.isHidden = false
            view_imageView_type_symbol.isHidden = true
            
            label_title_type.text = "型別"
            label_cost_symbol.text = "(-)"
            
            if timeChangeArr.getObject(at: indexPath.row) != nil {
                switch indexPath.row {
                case 1:
                    label_time_symbol.text = "(⇩)"
                    break
                case 2:
                    label_time_symbol.text = "(⇧)"
                    break
                default:
                    label_time_symbol.text = "(-)"
                    break
                }
                resetList(symbol: .time, row: indexPath.row, changeType: "")
            }
            presentedViewController?.dismiss(animated: true, completion: nil)
            break
        case 3: // 選型別
            label_time_symbol.text = "(-)"
            label_cost_symbol.text = "(-)"
            if let detail = locatedManager.array_allItemsURL.getObject(at: indexPath.row) {
                if detail == "unlimited" {
                    label_title_type.isHidden = false
                    view_imageView_type_symbol.isHidden = true
                    
                    label_title_type.text = "型別"
                } else {
                    label_title_type.isHidden = true
                    view_imageView_type_symbol.isHidden = false
                    
                    guard let tintedTmage = UIImage(named: detail)?.withRenderingMode(.alwaysTemplate) else { return }
                    imageView_type_symbol.image = tintedTmage
                }
                resetList(symbol: .type, row: indexPath.row, changeType: indexPath.row == 0 ? "" : detail)
            }
            presentedViewController?.dismiss(animated: true, completion: nil)
            break
        case 4: // 選金額
            label_title_type.isHidden = false
            view_imageView_type_symbol.isHidden = true
            
            label_time_symbol.text = "(-)"
            label_title_type.text = "型別"
            
            if costChangeArr.getObject(at: indexPath.row) != nil {
                switch indexPath.row {
                case 1:
                    label_cost_symbol.text = "(⇩)"
                    break
                case 2:
                    label_cost_symbol.text = "(⇧)"
                    break
                default:
                    label_cost_symbol.text = "(-)"
                    break
                }
                resetList(symbol: .cost, row: indexPath.row, changeType: "")
            }
            presentedViewController?.dismiss(animated: true, completion: nil)
            break
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
