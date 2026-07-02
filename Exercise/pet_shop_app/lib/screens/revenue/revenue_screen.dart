import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({Key? key}) : super(key: key);

  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    
    // Filter orders based on selected date
    final filteredOrders = _selectedDate == null 
        ? orderProvider.orders 
        : orderProvider.orders.where((o) => 
            o.dateTime.year == _selectedDate!.year && 
            o.dateTime.month == _selectedDate!.month && 
            o.dateTime.day == _selectedDate!.day
          ).toList();

    double totalRevenue = 0.0;
    for (var order in filteredOrders) {
      totalRevenue += order.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _selectedDate == null 
                        ? 'Total Revenue (All Time)' 
                        : 'Revenue for ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${totalRevenue.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text('${filteredOrders.length} orders completed'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (ctx, i) {
                final order = filteredOrders[i];
                return ExpansionTile(
                  title: Text('\$${order.amount.toStringAsFixed(2)}'),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(order.dateTime)),
                  children: order.products.map((prod) => ListTile(
                    title: Text(prod.product.name),
                    trailing: Text('${prod.quantity}x \$${prod.product.price}'),
                  )).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
