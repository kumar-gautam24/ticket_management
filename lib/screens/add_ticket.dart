import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_management/blocs/ticket_bloc/ticket_bloc_bloc.dart';
import 'package:ticket_management/models/ticket_model.dart';

class AddTicketScreen extends StatefulWidget {
  final String userId;
  const AddTicketScreen({super.key, required this.userId});

  @override
  _AddTicketScreenState createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  // Function to dispatch AddTicketEvent
  void _addTicket() {
    final ticket = TicketModel(
      id: '',
      title: _titleController.text.trim(),
      status: 'open',
      assignedTo: '',
      createdBy: widget.userId,
    );

    BlocProvider.of<TicketBlocBloc>(context).add(AddTicketEvent(ticket));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<TicketBlocBloc, TicketBlocState>(
          listener: (context, state) {
            if (state is TicketsLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is TicketBlocAction) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              BlocProvider.of<TicketBlocBloc>(context)
                  .add(FetchTicketsEvent(userId: widget.userId));
              Navigator.pop(context);
            } else if (state is TicketErrorState) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Ticket Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _addTicket,
                    child: const Text('Add Ticket'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
