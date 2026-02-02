import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackbar {
  OverlayEntry? _overlayEntry;

  void showCustomSnackbar(
    BuildContext context,
    String message, {
    Color bgColor = const Color(0xFF1E1E1E),
    IconData? icon,
    Color iconColor = Colors.white,
    Duration showDuration = const Duration(seconds: 2), // slow appear
    Duration hideDuration = const Duration(milliseconds: 400), // fast disappear
  }) {
    _removeCurrentSnackbar();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarAnimationWidget(
        message: message,
        bgColor: bgColor,
        icon: icon,
        iconColor: iconColor,
        showDuration: showDuration,
        hideDuration: hideDuration,
        onClosed: _removeCurrentSnackbar,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeCurrentSnackbar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _SnackbarAnimationWidget extends StatefulWidget {
  final String message;
  final Color bgColor;
  final IconData? icon;
  final Color iconColor;
  final Duration showDuration;
  final Duration hideDuration;
  final VoidCallback onClosed;

  const _SnackbarAnimationWidget({
    required this.message,
    required this.bgColor,
    this.icon,
    required this.iconColor,
    required this.showDuration,
    required this.hideDuration,
    required this.onClosed,
  });

  @override
  State<_SnackbarAnimationWidget> createState() =>
      _SnackbarAnimationWidgetState();
}

class _SnackbarAnimationWidgetState extends State<_SnackbarAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Total animation: appear slowly, then hide quickly
    _controller = AnimationController(
      vsync: this,
      duration: widget.showDuration + widget.hideDuration,
    );

    // Custom Tween: start from bottom, go up
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 1.5), // below the screen
          end: const Offset(0, 0), // visible
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: widget.showDuration.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0), // visible
          end: const Offset(0, -1.7), // slide above screen quickly
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: widget.hideDuration.inMilliseconds.toDouble(),
      ),
    ]).animate(_controller);

    _controller.forward();

    // Remove overlay when animation ends
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onClosed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.bgColor.withOpacity(0.95),
                  widget.bgColor.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: widget.bgColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: widget.iconColor, size: 26),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
