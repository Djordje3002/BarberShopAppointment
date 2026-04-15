import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published var items: [NewsModel] = []

    init() {
        load()
    }

    func load() {
        items = [
            NewsModel(
                title: "Grand Opening of our New Station",
                subtitle: "We've added a fifth station to keep up with demand!",
                imageName: "barber-1",
                date: Date(),
                content: "To better serve our loyal clients, we have officially opened a fifth barber station. This means more available slots and less waiting time. Come visit us and see the new setup!"
            ),
            NewsModel(
                title: "Weekend Beard Special",
                subtitle: "Free beard trim with every haircut this Friday and Saturday.",
                imageName: "barber-2",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                content: "Is your beard looking a bit wild? Book any haircut service this Friday or Saturday and get a professional beard trim on the house. Limited spots available!"
            ),
            NewsModel(
                title: "New Premium Hair Products",
                subtitle: "Exclusive pomades and beard oils now in stock.",
                imageName: "barber-3",
                date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                content: "We are excited to announce a new partnership with premium grooming brands. We now stock high-quality pomades, beard oils, and shampoos that we use in-shop. Ask your barber for a recommendation!"
            ),
            NewsModel(
                title: "Meet the New Team Member",
                subtitle: "Welcoming Marco, our newest expert in classic fades.",
                imageName: "barber-0",
                date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                content: "Marco joins us with over 10 years of experience in traditional barbering. He specializes in skin fades and hot towel shaves. Book your next appointment with Marco today!"
            ),
            NewsModel(
                title: "Holiday Hours Announcement",
                subtitle: "Check our updated schedule for the upcoming month.",
                imageName: nil,
                date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
                content: "We will be adjusting our hours for the upcoming holidays. We will be closed on December 25th and January 1st. Make sure to book your holiday haircut early!"
            )
        ]
    }
}
