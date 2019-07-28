//
//  MeasurementPicker.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import JanitorKit



struct MeasurementPicker<Unit: MeasurementUnit>: View {
    
    @Binding
    private var value: Measurement.Value
    
    @Binding
    private var unit: Unit
    
    /// A short string of text describing the context of the picker. For instance, if picking an age, this might be `"No older than"` or `"At least"`
    var preamble: String?
    
    /// A short string of text describing the context of the picker. For instance, if picking an age, this might be `"No older than"` or `"At least"`
    var postamble: String?
    
    
    init(preamble: String?, measurement initialAge: Binding<Measurement>, postamble: String?) {
        
        self.preamble = preamble
        self.postamble = postamble
        
        self._value = Binding(
            getValue: {
                return initialAge.value.value
            },
            setValue: { newValue in
                initialAge.value = Measurement(value: newValue, unit: initialAge.value.unit)
            }
        )
        
        self._unit = Binding(
            getValue: {
                return initialAge.value.unit
            },
            setValue: { newUnit in
                initialAge.value = Measurement(value: initialAge.value.value, unit: newUnit)
            }
        )
    }
    
    
    var body: some View {
        HStack {
            if nil != preamble {
                Text(preamble!) // 🤮 I hope they fix this before SwiftUI goes public
            }
            TextField("value", value: $value, formatter: numberFormatter)
            Picker("unit", selection: $unit, content: {
                ForEach(Age.Unit.casesLargerThanSeconds) { ageUnit in
                    Text(ageUnit.name.text(for: self.value)).tag(ageUnit)
                }
            })
                .pickerStyle(.popUpButton)
            if nil != postamble {
                Text(postamble!) // 🤮 I hope they fix this before SwiftUI goes public
            }
        }
    }
    
    
    private var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumIntegerDigits = 4
        
        return numberFormatter
    }()
    
    
    
    typealias Measurement = JanitorKit.Measurement<Unit>
}



#if DEBUG
struct MeasurementPicker_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementPicker(preamble: "No older than", measurement: .constant(1.days), postamble: nil)
    }
}
#endif
