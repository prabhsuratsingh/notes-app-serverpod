import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  final Exception? exception;
  final VoidCallback onTryAgain;

  const LoadingScreen({
    super.key,
    required this.exception,
    required this.onTryAgain,
    });

  @override
  Widget build(BuildContext context) {
    if (exception != null) {
      return Center(
        child: ElevatedButton(
          onPressed: onTryAgain,
          child: const Text('Connection Failed. Try Again!'),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}