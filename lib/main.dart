import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final List<Variant> variants;

  Product({required this.name, required this.variants});
}

class Variant {
  final String name;
  final double price;

  Variant({required this.name, required this.price});
}

class Order {
  final Product product;
  final Variant variant;
  final int quantity;

  Order({required this.product, required this.variant, required this.quantity});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orders = [];

  void addOrder(Product product, Variant variant, int quantity) {
    setState(() {
      orders.add(Order(product: product, variant: variant, quantity: quantity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('${order.product.name} - ${order.variant.name}'),
            subtitle: Text('Quantity: ${order.quantity}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductSelectionScreen(addOrder: addOrder)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductSelectionScreen extends StatelessWidget {
  final Function addOrder;

  ProductSelectionScreen({super.key, required this.addOrder});

  final List<Product> products = [
    Product(
      name: 'Munch',
      variants: [
        Variant(name: 'Regular', price: 10),
      ],
    ),
    Product(
      name: 'DairyMilk',
      variants: [
        Variant(name: '10g - Regular', price: 10),
        Variant(name: '35g - Regular', price: 30),
        Variant(name: '110g - Regular', price: 80),
        Variant(name: '110g - Silk', price: 95),
      ],
    ),
    Product(
      name: 'KitKat',
      variants: [
        Variant(name: 'Regular', price: 15),
      ],
    ),
    Product(
      name: 'FiveStar',
      variants: [
        Variant(name: 'Regular', price: 20),
      ],
    ),
    Product(
      name: 'Perk',
      variants: [
        Variant(name: 'Regular', price: 25),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Product'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VariantSelectionScreen(product: product, addOrder: addOrder)),
              );
            },
          );
        },
      ),
    );
  }
}

class VariantSelectionScreen extends StatelessWidget {
  final Product product;
  final Function addOrder;

  const VariantSelectionScreen({super.key, required this.product, required this.addOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Variant'),
      ),
      body: ListView.builder(
        itemCount: product.variants.length,
        itemBuilder: (context, index) {
          final variant = product.variants[index];
          return ListTile(
            title: Text(variant.name),
            subtitle: Text('Price: ₹${variant.price}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuantitySelectionScreen(product: product, variant: variant, addOrder: addOrder)),
              );
            },
          );
        },
      ),
    );
  }
}

class QuantitySelectionScreen extends StatefulWidget {
  final Product product;
  final Variant variant;
  final Function addOrder;

  const QuantitySelectionScreen({super.key, required this.product, required this.variant, required this.addOrder});

  @override
  _QuantitySelectionScreenState createState() => _QuantitySelectionScreenState();
}

class _QuantitySelectionScreenState extends State<QuantitySelectionScreen> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quantity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Quantity: $quantity',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.addOrder(widget.product, widget.variant, quantity);
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
              child: const Text('Add to Order'),
            ),
          ],
        ),
      ),
    );
  }
}
