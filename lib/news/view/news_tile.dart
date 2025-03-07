import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const NewsTile({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: const Icon(Icons.article, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.black87,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          description,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[700],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
      onTap: onTap,
    );
  }
}
