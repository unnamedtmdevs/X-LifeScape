//
//  SettingsView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = true
    @AppStorage("userName") var userName = ""
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @AppStorage("darkModeEnabled") var darkModeEnabled = false
    
    @State private var showingResetAlert = false
    @State private var tempUserName = ""
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Your name", text: $tempUserName, onCommit: {
                            userName = tempUserName
                        })
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.appPrimary)
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .tint(.appPrimary)
                    
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                        .tint(.appPrimary)
                }
                
                Section(header: Text("Data")) {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Text(AppStrings.resetAccount)
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("App")
                        Spacer()
                        Text("X-LifeScape")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                tempUserName = userName
            }
        }
        .navigationTitle(AppStrings.settings)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .alert(AppStrings.resetAccount, isPresented: $showingResetAlert) {
            Button("Reset", role: .destructive) {
                resetApp()
            }
            Button(AppStrings.cancel, role: .cancel) {}
        } message: {
            Text(AppStrings.resetConfirmation)
        }
    }
    
    func resetApp() {
        // Reset onboarding
        hasCompletedOnboarding = false
        
        // Reset data
        DataService.shared.resetAllData()
        
        // Reset preferences
        userName = ""
        tempUserName = ""
        notificationsEnabled = true
        darkModeEnabled = false
    }
}

