//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    @State private var isTransactionAppear = false
    @ObservedObject var viewModel: AccountDetailViewModel = AccountDetailViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            VStack(spacing: 10) {
                Text("Total ammount")
                    .font(.headline)
                Text("\(viewModel.currentBalance)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(hex: "#94A684")) // Using the green color you provided
                Image(systemName: "eurosign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(Color(hex: "#94A684"))
            }
            .padding(.top)
            
            // Display recent transactions
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Transactions")
                    .font(.headline)
                    .padding([.horizontal])
                VStack {
                    List (viewModel.recentTransactions, id: \.label) { transaction in
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
                    }
                    .listStyle(.plain)
                }
            }
            
            // Button to see details of transactions
            Button(action: {
                // Implement action to show transaction details
                isTransactionAppear = true
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("See Transaction Details")
                }
                .padding()
                .background(Color(hex: "#94A684"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding([.horizontal, .bottom])
            
            Spacer()
        }
        
        .onTapGesture {
            self.endEditing(true)  // This will dismiss the keyboard when tapping outside
        }
        .onAppear{
            DispatchQueue.main.async {
                viewModel.getAccountVM()
            }
        }
        .sheet(isPresented: $isTransactionAppear, content: {
            TransactionListView(viewModel: viewModel)
        })
    }
}

#Preview {
    AccountDetailView()
}
