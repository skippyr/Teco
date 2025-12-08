//
//  File: CellUnit.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
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
