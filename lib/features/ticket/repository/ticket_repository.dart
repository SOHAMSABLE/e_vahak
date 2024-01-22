import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vahak/core/providers/firebase_providers.dart';
import 'package:e_vahak/features/auth/repository/auth_repository.dart';
import 'package:e_vahak/models/tickets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTicketProvider = StreamProvider((ref) {
  String uid = ref.read(userIdprovider);
  return ref.read(ticketRepositoryProvider).getTickets(uid);
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return TicketRepository(firestore: ref.read(firestoreProvider));
});

final ticketProvider = StateProvider<TicketModel>((ref) => TicketModel(
      source: '',
      destination: '',
      date: '',
      time: '',
      ticketId: '',
      busId: '',
      uid: '',
      price: 0,
      fullSeats: 0,
      halfSeats: 0,
    ));

class TicketRepository {
  final FirebaseFirestore _firestore;
  TicketRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _tickets => _firestore.collection('tickets');

  Future<void> addTicket(TicketModel ticket, String uid) async {
    ticket.copyWith(date: DateTime.now().toString(),time: DateTime.now().toString(),uid: uid);
    try {
      await _tickets.add(ticket.toMap());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream<List<TicketModel>> getTickets(String uid) {
    return _tickets
        .where('uid', isEqualTo:uid )
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => TicketModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  void updateTicketSource(String source, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(source: source));
  }

  void updateTicketDestination(
      String destination, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(destination: destination));
  }

  void updateTicketDate(String date, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(date: date));
  }

  void updateTicketTime(String time, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(time: time));
  }

  void updateTicketId(String ticketId, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(ticketId: ticketId));
  }

  void updateTicketBusId(String busId, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(busId: busId));
  }

  void updateTicketUid(String uid, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(uid: uid));
  }

  void updateTicketPrice(int price, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(price: price));
  }

  void updateTicketFullSeats(int fullSeats, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(fullSeats: fullSeats));
  }

  void updateTicketHalfSeats(int halfSeats, WidgetRef ref, TicketModel ticket) {
    ref
        .read(ticketProvider.notifier)
        .update((state) => ticket.copyWith(halfSeats: halfSeats));
  }
}
