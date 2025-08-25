class NotificationModel {
  final String imagePath;
  final String title;
  final String description;
  final bool isRead;
  final String dayAgo; // e.g. "2d ago", "3 hours ago"

  NotificationModel({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isRead,
    required this.dayAgo,
  });

  // Factory method to create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      imagePath: json['imagePath'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isRead: json['isRead'] ?? false,
      dayAgo: json['dayAge'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'isRead': isRead,
      'dayAge': dayAgo,
    };
  }
}

// Dummy data
final List<Map<String, dynamic>> dummyNotifications = [
  {
    "imagePath": "Icons.notifications",
    "title": "Special Offer",
    "description": "Get 20% off on your next purchase.",
    "isRead": false,
    "dayAge": "2h ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Order Shipped",
    "description": "Your order #1234 has been shipped.",
    "isRead": true,
    "dayAge": "1d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Wallet Update",
    "description": "₹500 has been added to your wallet.",
    "isRead": false,
    "dayAge": "3d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Latest News",
    "description": "New features are now available in the app.",
    "isRead": true,
    "dayAge": "1w ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Special Offer",
    "description": "Get 20% off on your next purchase.",
    "isRead": false,
    "dayAge": "2h ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Order Shipped",
    "description": "Your order #1234 has been shipped.",
    "isRead": true,
    "dayAge": "1d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Wallet Update",
    "description": "₹500 has been added to your wallet.",
    "isRead": false,
    "dayAge": "3d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Latest News",
    "description": "New features are now available in the app.",
    "isRead": true,
    "dayAge": "1w ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Special Offer",
    "description": "Get 20% off on your next purchase.",
    "isRead": false,
    "dayAge": "2h ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Order Shipped",
    "description": "Your order #1234 has been shipped.",
    "isRead": true,
    "dayAge": "1d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Wallet Update",
    "description": "₹500 has been added to your wallet.",
    "isRead": false,
    "dayAge": "3d ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Latest News",
    "description": "New features are now available in the app.",
    "isRead": true,
    "dayAge": "1w ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Special Offer",
    "description": "Get 20% off on your next purchase.",
    "isRead": false,
    "dayAge": "2h ago",
  },
  {
    "imagePath": "Icons.notifications",
    "title": "Order Shipped",
    "description": "Your order #1234 has been shipped.",
    "isRead": true,
    "dayAge": "1d ago",
  },
];
