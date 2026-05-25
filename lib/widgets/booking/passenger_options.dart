import 'package:flight_app/models/ggModel/list_item.dart';
import 'package:flight_app/models/ggModel/booking.dart';

final List<ListItem> passengerOptions = [
  ListItem(
      value: passengerList[0].id,
      label: ' ${passengerList[0].username}',
      text: 'ID Number: ${passengerList[0].idCard}'),
  ListItem(
      value: passengerList[1].id,
      label: ' ${passengerList[1].username}',
      text: 'ID Number: ${passengerList[1].idCard}'),
  ListItem(
      value: passengerList[2].id,
      label: ' ${passengerList[2].username}',
      text: 'ID Number: ${passengerList[2].idCard}'),
  ListItem(
      value: passengerList[3].id,
      label: ' ${passengerList[3].username}',
      text: 'ID Number: ${passengerList[3].idCard}'),
  ListItem(
      value: passengerList[4].id,
      label: ' ${passengerList[4].username}',
      text: 'ID Number: ${passengerList[4].idCard}'),
];
