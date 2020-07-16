//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Артем Стратиенко on 20/11/2019.
//  Copyright © 2019 Артем Стратиенко. All rights reserved.
//

import UIKit

private let borderWidth: CGFloat = 1
private let cornerRadius: CGFloat = 12

class BottomSheetView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = borderWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
 
        // Make sure border isn't visible
        layer.bounds = CGRect(origin: bounds.origin,
                              size: CGSize(width: bounds.size.width - borderWidth * 2,
                                           height: bounds.size.height - 100))
    }
}
