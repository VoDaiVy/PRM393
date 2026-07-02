import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Admin Dashboard' : 'Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeTab(context) : _buildInventoryTab(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/products/add'),
              backgroundColor: const Color(0xFFFF8A65),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    
    final totalRevenue = orderProvider.orders.fold(0.0, (sum, item) => sum + item.amount);
    final totalOrders = orderProvider.orders.length;
    final totalProducts = productProvider.items.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Total Revenue',
                  value: '\$${totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Total Orders',
                  value: '$totalOrders',
                  icon: Icons.shopping_bag_outlined,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            title: 'Total Products in Store',
            value: '$totalProducts',
            icon: Icons.inventory_2_outlined,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          orderProvider.orders.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No orders yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderProvider.orders.length > 5 ? 5 : orderProvider.orders.length,
                  itemBuilder: (ctx, i) {
                    final order = orderProvider.orders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () => _showOrderDetails(context, order),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFEEEEEE),
                          child: Icon(Icons.receipt, color: Colors.black54),
                        ),
                        title: Text('Order #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${order.dateTime.toString().substring(0, 16)}'),
                        trailing: Text(
                          '\$${order.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.filteredAndSortedItems;
    final categories = productProvider.categories;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products by name...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) => productProvider.setSearchQuery(value),
          ),
        ),
        
        // Category Chips
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = productProvider.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) productProvider.setCategory(cat);
                  },
                  selectedColor: const Color(0xFFFF8A65),
                  backgroundColor: Colors.white,
                  side: isSelected ? BorderSide.none : const BorderSide(color: Colors.black12),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            },
          ),
        ),
        
        // Product List View
        Expanded(
          child: products.isEmpty
            ? const Center(child: Text('No products found.', style: TextStyle(color: Colors.grey, fontSize: 16)))
            : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(bottom: 100),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                      ? Image.network(product.imageUrl!, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: Colors.black12, width: 60, height: 60, child: const Icon(Icons.pets, color: Colors.grey)))
                      : Container(color: Colors.black12, width: 60, height: 60, child: const Icon(Icons.pets, color: Colors.grey)),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)} • ${product.category}',
                      style: const TextStyle(color: Color(0xFFFF8A65), fontWeight: FontWeight.w600),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => context.push('/products/edit/${product.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text('Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
                                TextButton(
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    productProvider.deleteProduct(product.id);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Order #${order.id.substring(0, 8)} Details'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${order.dateTime.toString().substring(0, 16)}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              const Text('Customer Info', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8A65))),
              Text('Name: ${order.userName}'),
              Text('Email: ${order.userEmail}'),
              const Divider(height: 24),
              const Text('Items Purchased', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF8A65))),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final item = order.products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.quantity}x ${item.product.name}')),
                          Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Paid:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('\$${order.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
