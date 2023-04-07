//
//  ContentView.swift
//  MicroRoulette Watch App
//
//  Created by Daniil Popov on 07/04/2023.
//

import SwiftUI


struct ContentView: View {
    private var numbers = 0...13

    @State private var oddEven = ["odd", "even"]
    @State private var number: Int = 0
    
    @State private var scrollAmount = 0.0
    @State private var progress = 0.0

    var body: some View {
        VStack(spacing: 0) {
            HStack {

                Picker("", selection: $oddEven) {
                    ForEach(oddEven, id: \.self) { item in Text(item) }
                }
                .padding()
                .focusable(true)
    
                Picker("", selection: $number) {
                    ForEach(numbers, id: \.self) { _ in Text("\(number)") }
                }
                .padding()
                .focusable(true)
                
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 65)
            .padding(.top, -30)
            
//            ZStack
//            {
//                Circle ()
//                    .stroke (lineWidth: 10)
//                    .opacity (0.2)
//                    .foregroundColor (.white)
//                    .frame (width: 120)
//
//                Circle()
//                    .offset (y: -60)
//                    .foregroundColor(.white)
//                    .frame (width: 10)
//                    .rotationEffect(Angle (degrees: progress))
//                    .focusable (true)
//                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, isContinuous: false)
//                    .onChange(of: scrollAmount) { value in
//                        self.progress = value
//                    }
//
//                Circle()
//                    .offset (y: -60)
//                    .foregroundColor(.white)
//                    .frame (width: 10)
//                    .rotationEffect(Angle (degrees: -progress))
//                    .focusable (true)
//                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, isContinuous: false)
//                    .onChange(of: scrollAmount) { value in
//                        self.progress = value
//                    }
//            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
