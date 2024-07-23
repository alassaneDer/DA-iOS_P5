//
//  TransactionListView.swift
//  Aura
//
//  Created by Alassane Der on 29/06/2024.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: AccountDetailViewModel = AccountDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Transactions")
                .font(.headline)
                .padding()
            VStack {
                List (viewModel.transactions, id: \.label) { transaction in
                    HStack {
                        Image(systemName: transaction.valueString.contains("-") ? "arrow.down.right.circle.fill" : "arrow.up.left.circle.fill")
                            .foregroundStyle(transaction.valueString.contains("-") ? .red : .green)
                        Text("\(transaction.label)")
                        Spacer()
                        Text("\(transaction.valueString)")
                            .bold()
                            .foregroundStyle(transaction.valueString.contains("-") ? .red : .green)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .listRowSeparator(.hidden)
//                        .padding([.horizontal])
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    TransactionListView()
}
