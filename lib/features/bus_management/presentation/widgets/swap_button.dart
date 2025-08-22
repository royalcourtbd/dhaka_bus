import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:flutter/material.dart';

class SwapButton extends StatefulWidget {
  const SwapButton({super.key, required this.busPresenter});

  final BusPresenter busPresenter;

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSwapTap() {
    // Start animation
    _animationController.forward().then((_) {
      _animationController.reset();
    });

    // Perform swap
    widget.busPresenter.swapLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: fortyPx,
      right: 17.percentWidth,
      child: GestureDetector(
        onTap: _onSwapTap,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle:
                  _rotationAnimation.value * 3.14159, // 180 degrees in radians
              child: Container(
                width: 15.percentWidth,
                height: 15.percentWidth,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
