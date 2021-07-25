//
//  MeasurementPicker.swift
//  MeasurementPicker
//
//  Created by Ben Leggiero on 2021-07-21.
//

import SwiftUI
import JanitorKit



struct MeasurementPicker<Unit: MeasurementUnit>: View {
    
    private let title: LocalizedStringKey
    
    @Binding
    private var selection: Measurement
    
    private let valueRange: ClosedRange<Measurement>
    
    
    init(_ title: LocalizedStringKey, selection: Binding<Measurement>, valueRange: ClosedRange<Measurement>) {
        self.title = title
        self._selection = selection
        self.valueRange = valueRange
    }
    
    
    var body: some View {
        HStack {
            if #available(macOS 12.0, *) {
                TextField(title, value: $selection.value, format: FloatingPointFormatStyle())
                    .frame(minWidth: 100)
                    .fixedSize()
            }
            else {
                TextField(title, text: .init(get: { selection.value.description },
                                             set: { newValue in Unit.Value(newValue).map { selection.value = $0 } }))
                    .frame(minWidth: 100)
                    .fixedSize()
            }
            
            Picker("", selection: $selection.unit) {
                ForEach(Unit.allCases.filter { valueRange.contains(Measurement(value: 1, unit: $0))  }) { unit in
                    Text(unit.name.text(whenAmountIs: selection.value))
                        .tag(unit)
                }
            }
        }
    }
    
    typealias Measurement = JanitorKit.Measurement<Unit>
}



struct MeasurementPicker_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementPicker("Amount of time:",
                          selection: .constant(Age(value: 7, unit: .day)),
                          valueRange: Age(value: .zero, unit: .second) ... Age(value: 50, unit: .year))
        
        MeasurementPicker("Data capacity:",
                          selection: .constant(DataSize(value: 1, unit: .gibibyte)),
                          valueRange: DataSize(value: .zero, unit: .bit) ... DataSize(value: 1, unit: .exbibyte))
    }
}
