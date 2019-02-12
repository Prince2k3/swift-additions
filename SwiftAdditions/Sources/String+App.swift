//
//  String+App.swift
//
//  Created by Prince Ugwuh on 1/4/18.
//

import UIKit

extension String {
    func attributedStringWithImagePrefix(isAirport: Bool) -> NSAttributedString {
        let imgAttachement = NSTextAttachment()
        if isAirport {
            imgAttachement.image = #imageLiteral(resourceName: "icon_airport_filled")
        } else {
            imgAttachement.image = #imageLiteral(resourceName: "icon_city")
        }
        let str = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imgAttachement))
        str.append(NSAttributedString(string: " \(self)"))
        return str
    }
}
