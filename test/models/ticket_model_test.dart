import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:ticket_management/models/ticket_model.dart';

void main() {
  group("ticket class unit test, from json ", () {
    test("fromJson ticket_test ", () {
      // Arrange : create json object
      final json = {
        'id': "1",
        'title': "title",
        'status': 'open',
        'assignedTo': 'assignedTo',
        'createdBy': 'createdBy'
      };
      // Act : create ticket from json
      final ticket = TicketModel.fromFirestore(json, json['id']!);
      // Debug: print the ticket object
      if (kDebugMode) {
        print(ticket);
      }
      // Assert : check that parsing is done correctly
      expect(ticket.id, json['id']);
      expect(ticket.title, json['title']);
      expect(ticket.status, json['status']);
      expect(ticket.assignedTo, json['assignedTo']);
      expect(ticket.createdBy, json['createdBy']);
    });
  });
}
