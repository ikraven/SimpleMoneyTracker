//
//  DoubleExtension.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/2/25.
//

import Foundation

extension Double{
    
    public func formatedAmount(showDecimals: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = showDecimals ? 2 : 0
        formatter.minimumFractionDigits = showDecimals ? 2 : 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
