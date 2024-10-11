//
//  EditCard.swift
//  FlashCard
//
//  Created by k.patrick on 11/10/2567 BE.
//

import SwiftUI

struct EditCard: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAns = ""
    var body: some View {
        NavigationStack{
            List{
                Section("Add new card"){
                    TextField("Prompt", text: $newPrompt)
                    TextField("Anser", text: $newAns)
                    Button("Add Card", action: addCard)

                }
                Section{
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading){
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Card")
            .toolbar{
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
    }
    func addCard(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAns = newAns.trimmingCharacters(in: .whitespaces)
        guard !trimmedPrompt.isEmpty && !trimmedAns.isEmpty else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAns)
        cards.insert(card, at: 0)
        saveData()
    }
    func removeCards(at offset: IndexSet){
        cards.remove(atOffsets: offset)
        saveData()
    }
    func done(){
        dismiss()
    }
    func loadData(){
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                cards = decoded
            }
        }
    }
    func saveData(){
        if let data = try?JSONEncoder().encode(cards){
            UserDefaults.standard.setValue(data, forKey: "Cards")
        }
    }
}

#Preview {
    EditCard()
}
