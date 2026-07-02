import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final String? productId; // null means Add, otherwise Edit

  const AddEditProductScreen({Key? key, this.productId}) : super(key: key);

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  String _description = '';
  double _price = 0.0;
  String _imageUrl = '';
  String _category = 'Others';

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      final product = Provider.of<ProductProvider>(context, listen: false).findById(widget.productId!);
      _name = product.name;
      _description = product.description;
      _price = product.price;
      _imageUrl = product.imageUrl ?? '';
      _category = product.category;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      if (widget.productId != null) {
        // Edit
        productProvider.updateProduct(
          widget.productId!,
          Product(
            id: widget.productId!,
            name: _name,
            description: _description,
            price: _price,
            imageUrl: _imageUrl.isEmpty ? null : _imageUrl,
            category: _category,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product updated')));
      } else {
        // Add
        productProvider.addProduct(
          Product(
            id: DateTime.now().toString(),
            name: _name,
            description: _description,
            price: _price,
            imageUrl: _imageUrl.isEmpty ? null : _imageUrl,
            category: _category,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added')));
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId != null ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a name.';
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category (e.g. Food, Toys)', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a category.';
                    return null;
                  },
                  onSaved: (value) {
                    _category = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _price > 0 ? _price.toString() : '',
                  decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a price.';
                    if (double.tryParse(value) == null) return 'Please enter a valid number.';
                    if (double.parse(value) <= 0) return 'Please enter a number greater than zero.';
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a description.';
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: const InputDecoration(labelText: 'Image URL (Optional)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.url,
                  onSaved: (value) {
                    _imageUrl = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Save Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
