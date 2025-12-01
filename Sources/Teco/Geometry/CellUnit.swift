//
//  CellUnit.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// The measurement unit used by terminals for sizes and positions.
public typealias CellUnit = UInt16

extension CellUnit {
    func saturatedAdd(to value: CellUnit) -> CellUnit {
        let (value, overflow) = addingReportingOverflow(value)
        return overflow ? CellUnit.max : value
    }

    func saturatedMultiply(to value: CellUnit) -> CellUnit {
        let (value, overflow) = multipliedReportingOverflow(by: value)
        return overflow ? CellUnit.max : value
    }
}
