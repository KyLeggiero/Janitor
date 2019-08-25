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
    
    private var value: Inout<Measurement.Value>
    
    private var unit: Inout<Unit>
    
    /// A short string of text describing the context of the picker. For instance, if picking an age, this might be `"No older than"` or `"At least"`
    var preamble: String?
    
    /// A short string of text describing the context of the picker. For instance, if picking an age, this might be `"No older than"` or `"At least"`
    var postamble: String?
    
    /// The units presented in this picker
    var presentedUnits: PresentedUnits
    
    
    private var valueForFormatter: Binding<NSNumber>
    
    
    init(preamble: String?, measurement initialMeasurement: Inout<Measurement>, presentedUnits: PresentedUnits = Unit.allCases, postamble: String?) {
        
        self.preamble = preamble
        self.presentedUnits = presentedUnits
        self.postamble = postamble
        
        self.value = Inout(
            get: {
                return initialMeasurement.wrappedValue.value
            },
            set: { newValue in
                initialMeasurement.wrappedValue.value = newValue// = Measurement(value: newValue, unit: initialMeasurement.wrappedValue.unit)
            }
        )
        
        self.unit = Inout(
            get: {
                return initialMeasurement.value.unit
            },
            set: { newUnit in
                initialMeasurement.wrappedValue.unit = newUnit//Measurement(value: initialMeasurement.wrappedValue.value, unit: newUnit)
//                initialMeasurement.update()
            }
        )
        
        self.valueForFormatter = .constant(0)
        self.valueForFormatter = Binding(get: self.nsNumberValue, set: self.setNsNumberValue)
    }
    
    
    var body: some View {
        HStack {
            if nil != preamble {
                Text(preamble!) // 🤮 I hope they fix this before SwiftUI goes public
            }
            TextField("value", value: value, formatter: numberFormatter)
            Picker("", selection: unit, content: {
                ForEach(presentedUnits) { ageUnit in
                    Text(ageUnit.name.text(whenAmountIs: self.value.value).localizedCapitalized).tag(ageUnit)
                }
            })
                .pickerStyle(PopUpButtonPickerStyle())
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
    
    
    private func nsNumberValue() -> NSNumber { NSNumber(value: value.value) }
    private nonmutating func setNsNumberValue(newValue: NSNumber) { value.value = .init(truncating: newValue) }
    
    
    
    typealias Measurement = JanitorKit.Measurement<Unit>
    typealias PresentedUnits = Unit.AllCases
}



#if DEBUG
struct MeasurementPicker_Previews: PreviewProvider {
    private static var exampleAge: Binding<Age> = .constant(1.days)
    private static var exampleDataSize: Binding<DataSize> = .constant(5.mebibytes)
    static var previews: some View {
        Group {
            MeasurementPicker(preamble: "No older than", measurement: exampleAge, postamble: nil)
            MeasurementPicker(preamble: "No more than", measurement: exampleDataSize, postamble: nil)
        }
    }
}
#endif
