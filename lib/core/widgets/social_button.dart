import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _isPressed ? 0.98 : 1,
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton(
            onPressed: enabled
                ? () {
                    widget.onPressed?.call();
                  }
                : null,
            onHover: (value) {
              setState(() => _isHovered = value);
            },
            onFocusChange: (_) {},
            style: OutlinedButton.styleFrom(
              elevation: 0,
              backgroundColor: _isHovered
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.05),
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withOpacity(0.18),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.white.withOpacity(0.08),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 26,
                        height: 26,
                        child: widget.icon,
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          widget.text,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .3,
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