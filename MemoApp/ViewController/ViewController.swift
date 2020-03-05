//
//  ViewController.swift
//  MemoApp
//
//  Created by 吉川椛 on 2019/11/21.
//  Copyright © 2019 com.litech. All rights reserved.
//


import UIKit

final class ViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let model = UserDefaultsModel()
    private var dataSource: [Memo] = [Memo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
//    static func instance() -> ViewController {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
//        return vc
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemos()
    }
    
    // MARK: IBAction
    
    @objc
    private func onTapAddButton(_ sender: UIBarButtonItem) {
        let vc = AddViewController.instance()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure

extension ViewController {
    
    private func configureUI() {
        navigationItem.title = "メモ一覧"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTapAddButton(_:)))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        print("tableView.delegate = self") OK
        tableView.tableFooterView = UIView()
//        print("tableView.FooterView = UIView()") OK
        tableView.rowHeight = TableViewCell.rowHeight
//        print("tableView.rowHeight") OK
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
//        print("tableview.regidter(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)") OK
    }
}

// MARK: - Model

extension ViewController {
    
    private func loadMemos() {
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
//        print("loadMemos") OK
    }
}

// MARK: - TableView dataSource, delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(dataSource.count) 011
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        tableView.register(TableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TableViewCell.self))
//        print("tableView.register(TableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TableViewCell.self))") OK
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
//        print("let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell") No
        let memo = dataSource[indexPath.row]
        cell.setupCell(title: memo.title, content: memo.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let memo = dataSource[indexPath.row]
        let vc = DetailViewController.instance(memo)
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 別の画面に遷移
        performSegue(withIdentifier: "toDetail", sender: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}