//
//  ContentView.swift
//  TimerBootcamp
//
//  Created by Weerawut Chaiyasomboon on 14/03/2568.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer.publish(every: 1, on: RunLoop.main, in: .common).autoconnect()
    
    //1. Current Date/Time
    @State private var currentDate = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    //2. Count down
    @State private var count: Int = 10
    @State private var finishedText: String?
    
    //3. Countdown to Date
    @State private var timeRemaining: String = ""
    let futureDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    private func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.hour,.minute,.second], from: Date(), to: futureDate)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(hour):\(minute):\(second)"
    }
    
    //4. Animation Counter
    @State private var count4 = 0
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.red,.yellow,.green], center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
            
            VStack {
                Text(dateFormatter.string(from: currentDate))
                    .font(.system(size: 100, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                Text(finishedText ?? "\(count)")
                    .font(.system(size: 100, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                Text(timeRemaining)
                    .font(.system(size: 100, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                HStack(spacing: 15) {
                    Circle()
                        .offset(y: count4 == 1 ? 20 : 0)
                    Circle()
                        .offset(y: count4 == 2 ? 20 : 0)
                    Circle()
                        .offset(y: count4 == 3 ? 20 : 0)
                }
                .foregroundStyle(.white)
                .frame(width: 200)
            }
        }
        .onReceive(timer) { value in
            //1
            currentDate = value
            
            //2
            if count <= 1 {
                finishedText = "Wow!!"
            } else {
                count -= 1
            }
            
            //3
            updateTimeRemaining()
            
            //4
            withAnimation(.easeInOut(duration: 0.5)) {
                count4 = count4 == 3 ? 0 : count4 + 1
            }
        }
    }
}

#Preview {
    ContentView()
}

struct PageAnimation: View {
    @State private var count: Int = 1
    
    let timer = Timer.publish(every: 2, on: RunLoop.main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $count) {
            Rectangle()
                .fill(.red)
                .tag(1)
            
            Rectangle()
                .fill(.green)
                .tag(2)
            
            Rectangle()
                .fill(.blue)
                .tag(3)
            
            Rectangle()
                .fill(.yellow)
                .tag(4)
            
            Rectangle()
                .fill(.teal)
                .tag(5)
        }
        .frame(height: 200)
        .tabViewStyle(.page)
        .onReceive(timer) { _ in
            withAnimation {
                count = count == 5 ? 1 : count + 1
            }
        }
    }
}

#Preview("Page Animation") {
    PageAnimation()
}
