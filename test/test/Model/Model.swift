//
//  Model.swift
//  test
//
//  Created by Dmitrii Imaev on 17.06.2024.
//

import Foundation

struct SampleDataSource: Hashable {
    private let outSender = SampleSender(
        senderId: "00", senderFullName: "Unknown", senderMeta: "Unk"
    )
    private let inSender = SampleSender(
        senderId: "01", senderFullName: "Long Sender Nameeeeeeeeeeee", senderMeta: "Patient"
    )
    
    func loadMessages(callback: @escaping (_ messages: [SampleMessage]) -> Void) {
        callback([
            SampleMessage(sender: self.inSender,
                          media: [
                            NSURL(string: "https://placekitten.com/200/300")!,
                            NSURL(string: "https://placekitten.com/300/300")!,
                            NSURL(string: "https://placekitten.com/g/400/400")!,
                          ],
                          sentTimestamp: "2023-01-25T16:50:00+03:00"),
            SampleMessage(sender: self.inSender,
                          media: [
                            NSURL(string: "https://placekitten.com/g/300/400")!
                          ],
                          sentTimestamp: "2023-01-29T09:00:00+03:00"),
            SampleMessage(sender: self.outSender,
                          media: [
                            NSURL(string: "https://placekitten.com/g/200/400")!
                          ],
                          sentTimestamp: "2023-01-31T10:30:00+03:00"),
            SampleMessage(sender: self.outSender,
                          media: [
                            NSURL(string: "https://placekitten.com/g/400/400")!,
                            NSURL(string: "https://placekitten.com/g/200/200")!,
                            NSURL(string: "https://placekitten.com/g/300/400")!,
                            NSURL(string: "https://placekitten.com/g/300/200")!,
                          ],
                          sentTimestamp: "2023-01-31T12:10:00+03:00")
        ])
    }
}

struct SampleMessage: Hashable {
    let sender: SampleSender?
    let media: [NSURL]?
    let sentTimestamp: String?
}

struct SampleSender: Hashable {
    let senderId: String
    let senderFullName: String
    let senderMeta: String?
}

