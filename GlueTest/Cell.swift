//
//  Cell.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

private struct Constants {
    static let backgroundColor: UIColor = .lightGray
    static let labelTextColor: UIColor = .white
}

class Cell: UICollectionViewCell, Reusable
{
    var poster: URL?

    let label = UILabel()
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        guard label.superview == nil
            else { return }

        self.backgroundColor = Constants.backgroundColor
        self.clipsToBounds = true
        self.label.configure(with: self)
    }
    
    func configure(with genre: String, poster: URL)
    {
        self.poster = poster
        self.label.text = genre
    }
    
    func addImage(from url: URL, image: UIImage)
    {
        guard self.poster == url
            else { return }
        
        self.backgroundView = UIImageView(image: image)
        self.backgroundView?.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.backgroundView = nil
        self.label.text = nil
        self.poster = nil
    }
}

private extension UILabel
{
    func configure(with parent: UIView)
    {
        parent.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: parent.widthAnchor, constant: -10),
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 10),
            self.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        ])
        
        self.backgroundColor = Constants.backgroundColor.withAlphaComponent(0.5)
        self.textColor = Constants.labelTextColor
    }
}
