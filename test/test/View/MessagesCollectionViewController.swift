//
//  MessangesTableViewController.swift
//  test
//
//  Created by Dmitrii Imaev on 17.06.2024.
//

import UIKit

final class MessangesTableViewController: UITableViewController {

    private var messages: [SampleMessage] = []
    private var currentUser: SampleSender?
    private let dataSource = SampleDataSource()
    private let cellID = String(describing: MessageTableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        loadMessages()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .unspecified
        currentUser = SampleSender(senderId: "00", senderFullName: "Default User", senderMeta: "User")
        
    }
    
    private func setupTableView() {
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    private func loadMessages() {
        dataSource.loadMessages { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension MessangesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        cell.configure(with: message, currentUid: currentUser?.senderId)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MessangesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
