import 'package:flutter/material.dart';

class BouncingImageLoader extends StatefulWidget {
  const BouncingImageLoader({super.key});

  @override
  State<BouncingImageLoader> createState() => _BouncingImageLoaderState();
}

class _BouncingImageLoaderState extends State<BouncingImageLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _bounce = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: AnimatedBuilder(
          animation: _bounce,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounce.value),
              child: child,
            );
          },
          child: Image.asset(
            'assets/icons/Loader.png', // ✅ Your logo path
            width: 54,
            height: 54,
          ),
        ),
      ),
    );
  }
}
