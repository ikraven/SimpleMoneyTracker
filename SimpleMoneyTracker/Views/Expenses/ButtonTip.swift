//
//  ButtonTip.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 19/3/25.
//

import Foundation
import TipKit

struct ButtonTip: Tip {
    var title: Text = Text("Vista mensual")
    var message: Text? = Text("Desliza para ver calendario con tus gastos mensuales.")
    var image: Image? = Image(systemName: "info.circle")
}
