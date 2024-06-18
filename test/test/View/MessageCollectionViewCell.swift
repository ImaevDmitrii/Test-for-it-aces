//
//  MessageTableViewCell.swift
//  test
//
//  Created by Dmitrii Imaev on 17.06.2024.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let bubbleView = UIView()
    private let nameAndMetaStackView = UIStackView()
    private let chatTextLabel = UILabel()
    private let metadataLabel = UILabel()
    private let mediaStackView = UIStackView()
    private let timeLabel = UILabel()
    
    private var textLeading: NSLayoutConstraint?
    private var textTrailing: NSLayoutConstraint?
    private var imageLeading: NSLayoutConstraint?
    private var imageTrailing: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        chatTextLabel.text = nil
        mediaStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        timeLabel.text = nil
    }
    
    func configure(with message: SampleMessage, currentUid: String?) {
        guard let currentUid = currentUid else {
            print("currentUid is nil")
            return
        }
        
        let isUser = currentUid == message.sender?.senderId
        if isUser {
            configureForUser()
        } else {
            configureForSender(message: message)
        }
        
        if let mediaURLs = message.media as? [URL] {
            configureMediaStackView(with: mediaURLs)
        }
        
        if let sentTimestamp = message.sentTimestamp {
            timeLabel.text = formatDate(timestamp: sentTimestamp)
        }
    }
    
    private func setupViews() {
        let padding: CGFloat = 8
        
        [profileImageView, bubbleView, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [nameAndMetaStackView, mediaStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bubbleView.addSubview($0)
        }
        
        [chatTextLabel, metadataLabel].forEach {
            nameAndMetaStackView.addArrangedSubview($0)
        }
        
        nameAndMetaStackView.axis = .horizontal
        nameAndMetaStackView.spacing = 4
        nameAndMetaStackView.alignment = .center
        nameAndMetaStackView.distribution = .fill
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
        
        bubbleView.layer.cornerRadius = 10
        
        chatTextLabel.numberOfLines = 1
        chatTextLabel.lineBreakMode = .byTruncatingTail
        chatTextLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        chatTextLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        metadataLabel.font = .systemFont(ofSize: 10)
        metadataLabel.textColor = .secondaryLabel
        metadataLabel.setContentHuggingPriority(.required, for: .horizontal)
        metadataLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        mediaStackView.axis = .horizontal
        mediaStackView.spacing = 8
        
        timeLabel.font = .systemFont(ofSize: 10)
        timeLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            profileImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            
            nameAndMetaStackView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: padding),
            nameAndMetaStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: padding),
            nameAndMetaStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -padding),
            
            mediaStackView.topAnchor.constraint(equalTo: nameAndMetaStackView.bottomAnchor, constant: padding),
            mediaStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            mediaStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            mediaStackView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -padding),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 260),
            
            timeLabel.bottomAnchor.constraint(equalTo: mediaStackView.bottomAnchor, constant: -padding),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -padding)
        ])
        
        imageLeading = profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6)
        imageTrailing = profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        
        textLeading = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16)
        textTrailing = bubbleView.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -16)
    }
    
    private func configureForUser() {
        nameAndMetaStackView.isHidden = true
        bubbleView.backgroundColor = .clear
        imageTrailing?.isActive = true
        textTrailing?.isActive = true
        imageLeading?.isActive = false
        textLeading?.isActive = false
        profileImageView.isHidden = true
    }
    
    private func configureForSender(message: SampleMessage) {
        chatTextLabel.text = message.sender?.senderFullName
        metadataLabel.text = message.sender?.senderMeta
        nameAndMetaStackView.isHidden = false
        bubbleView.backgroundColor = .secondarySystemBackground
        imageLeading?.isActive = true
        textLeading?.isActive = true
        imageTrailing?.isActive = false
        textTrailing?.isActive = false
        profileImageView.backgroundColor = .systemGray
        profileImageView.tintColor = .label
        profileImageView.isHidden = false
        profileImageView.image = generateInitialsImage(name: message.sender?.senderFullName)
    }
    
    private func configureMediaStackView(with mediaURLs: [URL]) {
        for (index, mediaURL) in mediaURLs.prefix(2).enumerated() {
            let imageView = createImageView()
            mediaStackView.addArrangedSubview(imageView)
            loadImage(from: mediaURL, into: imageView)
            
            if index == 1 && mediaURLs.count > 2 {
                let label = createOverlayLabel(with: mediaURLs.count - 1)
                imageView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
                ])
            }
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        return imageView
    }
    
    private func createOverlayLabel(with additionalCount: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+\(additionalCount)"
        label.textColor = .white
        label.font = .systemFont(ofSize: 26)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        if let cachedImage = ImageCache.getImage(forKey: url.absoluteString) {
            imageView.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "default")
                    }
                    return
                }
                ImageCache.setImage(image, forKey: url.absoluteString)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }.resume()
        }
    }
    
    private func generateInitialsImage(name: String?) -> UIImage? {
        guard let name = name else { return nil }
        let initials = name.split(separator: " ").prefix(2).map { String($0.prefix(1)) }.joined()
        let label = UILabel()
        label.frame.size = CGSize(width: 32, height: 32)
        label.text = initials
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        
        UIGraphicsBeginImageContext(label.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func formatDate(timestamp: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: timestamp) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return ""
    }
}
