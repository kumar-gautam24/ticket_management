class TicketModel {
  final String id;
  final String title;
  final String status;
  final String? assignedTo;
  final String createdBy;

  TicketModel({
    required this.id,
    required this.title,
    
    required this.status,
    this.assignedTo,
    required this.createdBy,
  });

  factory TicketModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TicketModel(
      id: id,
      title: data['title'],
      status: data['status']??"open",
      assignedTo: data['assignedTo'],
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'status': status,
        'assignedTo': assignedTo,
        'createdBy': createdBy,
      };
}
