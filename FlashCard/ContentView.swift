//
//  ContentView.swift
//  FlashCard
//
//  Created by k.patrick on 11/10/2567 BE.
//

import SwiftUI

extension View {
    func stacked(at position:Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset*10)
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var isactive = true
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var showingEditScreen = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack{
                
                Text("TIME : \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack{
                    ForEach(0..<cards.count, id: \.self){index in
                        CardView(card: cards[index]){
                            withAnimation{
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count-1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again?", action: resetCard)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                        .padding()
                    
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button{
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black)
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
        }
        
        .onReceive(timer){ time in
            guard isactive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase){
            if scenePhase == .active {
                if !cards.isEmpty {
                    isactive = true
                }
            } else {
                isactive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCard, content: EditCard.init)
        .onAppear(perform: resetCard)
    }
    func removeCard(at index:Int){
        cards.remove(at: index)
        if cards.isEmpty {
            isactive = false
        }
    }
    
    func resetCard() {
        timeRemaining = 100
        isactive = true
        loadData()
    }
    func loadData(){
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                cards = decoded
            }
        }
    }
}

#Preview {
    ContentView()
}
