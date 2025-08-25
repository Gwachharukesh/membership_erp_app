class OrderModel {
  final String title;
  final String orderProducts; // comma-separated product names
  final String status;

  OrderModel({
    required this.title,
    required this.orderProducts,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      title: json['title'],
      orderProducts: json['orderProducts'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'orderProducts': orderProducts, 'status': status};
  }
}

final ordersData = [
  {
    "title": "Order #1001",
    "orderProducts": "Laptop, Mouse, Keyboard",
    "status": "Completed"
  },
  {
    "title": "Order #1002",
    "orderProducts": "Mobile Phone, Charger, Earphones",
    "status": "Completed"
  },
  {
    "title": "Order #1003",
    "orderProducts": "T-Shirt, Jeans, Sneakers",
    "status": "Completed"
  },
  {
    "title": "Order #1004",
    "orderProducts": "Coffee Maker, Blender, Toaster",
    "status": "Cancelled"
  },
  {
    "title": "Order #1005",
    "orderProducts": "Book, Pen, Notebook",
    "status": "Cancelled"
  },
  {
    "title": "Order #1006",
    "orderProducts": "Headphones, Power Bank, USB Cable",
    "status": "Completed"
  },
  {
    "title": "Order #1007",
    "orderProducts": "Washing Machine, Vacuum Cleaner",
    "status": "Completed"
  },
  {
    "title": "Order #1008",
    "orderProducts": "Tablet, Stylus, Case",
    "status": "Completed"
  },
  {
    "title": "Order #1009",
    "orderProducts": "Shoes, Socks, Cap",
    "status": "Cancelled"
  },
  {
    "title": "Order #1010",
    "orderProducts": "Smartwatch, Fitness Band",
    "status": "Completed"
  }
];
