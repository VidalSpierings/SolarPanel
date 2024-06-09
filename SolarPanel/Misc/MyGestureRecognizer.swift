//
//  MyGestureRecognizer.swift
//  SolarPanel
//
//  Created by Vidal on 12/05/2024.
//

import UIKit

final class MyGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> ()) {
        
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(executeAction))
        
    }

    @objc private func executeAction() {
        
        action()
        
    }
}
