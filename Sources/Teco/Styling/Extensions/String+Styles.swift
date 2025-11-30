//
//  String+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension String {
    func rawPad(using padding: TextPadding) -> String {
        let count = max(0, Int(padding.length) - count)
        switch padding.alignment {
        case .left:
            return self + String(repeating: padding.character, count: count)
        case .right:
            return String(repeating: padding.character, count: count) + self
        case .center:
            let leftCount = count / 2
            let rightCount = count - leftCount
            return String(repeating: padding.character, count: leftCount) + self + String(repeating: padding.character, count: rightCount)
        }
    }
}
