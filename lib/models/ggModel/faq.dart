class Faq {
  Faq({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

// final List<Faq> faqData = [
//   Faq(
//     expandedValue:
//         'You can easily search for domestic and international flights by entering your departure city, destination, and travel date. The system will display available flights, prices, and schedules in real time.',
//     headerValue: 'How to Search for Flights?',
//   ),
//   Faq(
//     expandedValue:
//         'After selecting your flight, you can complete your booking by entering passenger information and making payment through the available payment methods on the platform.',
//     headerValue: 'How to Book a Flight Ticket?',
//   ),
//   Faq(
//     expandedValue:
//         'You can view your booking details, payment status, and ticket information from your account dashboard after successfully completing your reservation.',
//     headerValue: 'Where Can I Check My Booking Information?',
//   ),
//   Faq(
//     expandedValue:
//         'If your payment was successful but your ticket was not issued, please contact customer support with your booking number and payment information for assistance.',
//     headerValue: 'Payment Completed but Ticket Not Issued?',
//   ),
//   Faq(
//     expandedValue:
//         'Flight changes and cancellations depend on the airline policy and ticket conditions. Additional service fees may apply depending on the selected fare type.',
//     headerValue: 'Can I Change or Cancel My Ticket?',
//   ),
//   Faq(
//     expandedValue:
//         'Passengers can save their personal information in the application to make future bookings faster and more convenient.',
//     headerValue: 'How to Save Passenger Information?',
//   ),
//   Faq(
//     expandedValue:
//         'For international travel, passengers must ensure that their passport validity and visa requirements meet the destination country regulations before departure.',
//     headerValue: 'What Documents Are Required for International Flights?',
//   ),
//   Faq(
//     expandedValue:
//         'You can contact customer support through the Help section or by using the contact information provided on the platform for booking and payment assistance.',
//     headerValue: 'How to Contact Customer Support?',
//   ),
// ];
