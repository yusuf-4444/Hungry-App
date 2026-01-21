import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/core/route/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _burgerController;
  late AnimationController _shimmerController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  late Animation<double> _burgerSlideAnimation;
  late Animation<double> _burgerFadeAnimation;
  late Animation<double> _burgerRotationAnimation;

  late Animation<double> _shimmerAnimation;
  String? _token;

  @override
  void initState() {
    super.initState();

    _initAnimations();

    _startAnimations();

    Future.delayed(const Duration(seconds: 4), () async {
      if (mounted) {
        _token = await PrefHelper.getToken();
        if (_token != null && _token!.isNotEmpty) {
          Navigator.pushReplacementNamed(context, AppRoutes.root);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    });
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Burger Animation Controller
    _burgerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _burgerSlideAnimation = Tween<double>(begin: 150.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _burgerController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _burgerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _burgerController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _burgerRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _burgerController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _burgerController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    _shimmerController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _burgerController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          children: [
            const Gap(150),
            // Animated Logo with Shimmer Effect
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Stack(
                      children: [
                        SvgPicture.asset("assets/logo/Hungry_.svg"),
                        AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return ClipRect(
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: const [
                                      Colors.transparent,
                                      Colors.white,
                                      Colors.transparent,
                                    ],
                                    stops: [
                                      _shimmerAnimation.value - 0.3,
                                      _shimmerAnimation.value,
                                      _shimmerAnimation.value + 0.3,
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcATop,
                                child: SvgPicture.asset(
                                  "assets/logo/Hungry_.svg",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            // Animated Burger Image
            AnimatedBuilder(
              animation: _burgerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _burgerSlideAnimation.value),
                  child: Transform.rotate(
                    angle: _burgerRotationAnimation.value,
                    child: Opacity(
                      opacity: _burgerFadeAnimation.value,
                      child: Image.asset(
                        "assets/splash/image 1.png",
                        width: 400,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
