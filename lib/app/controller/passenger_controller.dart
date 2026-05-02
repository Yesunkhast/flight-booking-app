import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/models/realModel/passenger.dart';
import 'package:get/get.dart';

class PassengerController extends GetxController {
  final RxList<Passenger> passengers = <Passenger>[].obs;
  final Rxn<Passenger> selectedPassenger = Rxn<Passenger>();
  final RxList<Passenger> bookingPassengers = <Passenger>[].obs;
  final RxBool passengersSelected = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPassengers();
  }

  // ─── Load all ────────────────────────────────────────────────────────────────
  Future<void> loadPassengers() async {
    try {
      isLoading.value = true;
      final result = await DatabaseService.instance.getAllPassengers();
      passengers.value = result;
      // print(passengers.value);
    } catch (e) {
      print('Error loading passengers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void initBookingPassengers(int total) {
    bookingPassengers.value = List.generate(total, (_) => passengerInit);
  }

  // ─── Add ─────────────────────────────────────────────────────────────────────
  Future<void> addPassenger({
    required String idCard,
    required String lastName,
    required String firstName,
    required String birthday,
    required String passportValidDate,
    required String gender,
    String? type,
  }) async {
    try {
      isLoading.value = true;
      final db = DatabaseService.instance;
      final passenger = await Passenger.create(
        idCard: idCard,
        lastName: lastName,
        firstName: firstName,
        birthday: birthday,
        passportValidDate: passportValidDate,
        gender: gender,
        type: type ?? 'ADU',
      );

      await db.insertPassenger(passenger);
      await loadPassengers();
      print("passenger  inserted: {${passenger.toMap()}}");
    } catch (e) {
      print('Error adding passenger: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Edit ────────────────────────────────────────────────────────────────────
  Future<void> editPassenger({
    required int id,
    String? idCard,
    String? lastName,
    String? fistName,
    String? birthday,
    String? passportValidDate,
    String? gender,
  }) async {
    try {
      isLoading.value = true;

      await DatabaseService.instance.editPassenger(
        id: id,
        idCard: idCard,
        lastName: lastName,
        fistName: fistName,
        birthday: birthday,
        passportValidDate: passportValidDate,
        gender: gender,
      );

      await loadPassengers();
    } catch (e) {
      print('Error editing passenger: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Delete ──────────────────────────────────────────────────────────────────
  Future<void> deletePassenger(int id) async {
    try {
      isLoading.value = true;
      await DatabaseService.instance.deletePassenger(id);
      passengers.removeWhere((p) => p.id == id);
    } catch (e) {
      print('Error deleting passenger: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setPassenger(int index, Passenger passenger) {
    // ignore: invalid_use_of_protected_member
    final list = List<Passenger>.from(passengers.value);
    if (index < list.length) {
      list[index] = passenger;
    } else {
      list.add(passenger);
    }
    passengers.value = list; // only updates memory
  }

  // ─── Select ──────────────────────────────────────────────────────────────────
  void selectPassenger(Passenger passenger) {
    selectedPassenger.value = passenger;
  }

  void clearSelected() {
    selectedPassenger.value = null;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  bool get hasPassengers => passengers.isNotEmpty;
  int get passengerCount => passengers.length;
}
