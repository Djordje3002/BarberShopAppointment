import SwiftUI

struct SeedBarberAccountsView: View {
    @StateObject private var seeder = BarberAccountSeeder()

    var body: some View {
        VStack(spacing: 0) {
            CustomNavBar(title: "Barber Accounts")

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Use this once to create barber login accounts in Firebase Authentication and write matching user role docs in Firestore.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    credentialsCard

                    Button {
                        Task {
                            await seeder.seedDefaultBarberAccounts()
                        }
                    } label: {
                        HStack {
                            if seeder.isSeeding {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                            Text(seeder.isSeeding ? "Seeding..." : "Create / Sync Barber Accounts")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(seeder.isSeeding)

                    if let statusMessage = seeder.statusMessage {
                        Text(statusMessage)
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }

                    if let errorMessage = seeder.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }

                    Text("After seeding, barbers log in from the normal login screen with these emails/passwords.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden()
    }

    private var credentialsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Default Credentials")
                .font(.headline)

            ForEach(BarberSeedCatalog.accounts) { account in
                VStack(alignment: .leading, spacing: 4) {
                    Text(account.name)
                        .font(.subheadline.weight(.semibold))
                    Text("Email: \(account.email)")
                        .font(.caption)
                    Text("Password: \(account.password)")
                        .font(.caption)
                    Text("barberId: \(account.barberId)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)

                if account.id != BarberSeedCatalog.accounts.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    SeedBarberAccountsView()
}
