
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ai_curhat_app/presentation/widgets/fx/glass_container.dart';

class BiometricGate extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const BiometricGate({
    super.key,
    required this.child,
    this.isEnabled = false,
  });

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void didUpdateWidget(BiometricGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isEnabled) {
      setState(() {
        _isAuthenticated = true;
      });
    } else if (!oldWidget.isEnabled && widget.isEnabled) {
       // Re-lock if enabling
       setState(() {
         _isAuthenticated = false;
       });
       _authenticate();
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (_) {
      // Catches PlatformException, MissingPluginException, etc.
      canCheckBiometrics = false;
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (widget.isEnabled && _canCheckBiometrics) {
      _authenticate();
    } else {
       setState(() {
        _isAuthenticated = true;
      });
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access AI Listener',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      // Handle MissingPluginException on unsupported platforms
      // Allow access when biometrics not available
      authenticated = true;
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticated = authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled || _isAuthenticated) {
      return widget.child;
    }

    // Locked Screen UI
    return Stack(
      children: [
        // Blur whatever is behind (though typically this is the root, so nothing rendered yet)
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withValues(alpha: 0.1)),
          ),
        ),

        Center(
          child: GlassContainer(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Color(0xFF607D8B)),
                const SizedBox(height: 24),
                const Text(
                  'App Locked',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF607D8B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
