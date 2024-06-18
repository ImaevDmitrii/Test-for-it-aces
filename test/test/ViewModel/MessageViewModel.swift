//
//  MessageViewModel.swift
//  test
//
//  Created by Dmitrii Imaev on 17.06.2024.
//

import Foundation

final class MessageViewModel {
    private var messages: [SampleMessage] = []
    private let dataSource = SampleDataSource()
    
    func loadMessages(completion: @escaping () -> Void) {
        dataSource.loadMessages { [weak self] loadedMessages in
            self?.messages = loadedMessages
            completion()
        }
    }
    
    func numberOfMessages() -> Int {
        return messages.count
    }
    
    func message(at index: Int) -> SampleMessage {
        return messages[index]
    }
}
