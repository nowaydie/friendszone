import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';
import 'components/custom_sign_in_dialog.dart';
import 'components/sign_in_form.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          // Positioned(
          //     height: 100,
          //     bottom: 700,
          //     left: 10,
          //     width: MediaQuery.of(context).size.width * 1.7,
          //     child: Image.asset("assets/Backgrounds/Spline.png")),
          AnimatedPositioned(
            top: isSignInDialogShown ? -50 : 0,
            duration: const Duration(milliseconds: 240),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: const [
                        Text(
                          'Watch content & friends',
                          style: TextStyle(
                              fontSize: 60,
                              fontFamily: "Poppins",
                              height: 1.2,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Уникальный сервис позволяющей смотреть контент вместе с друзьями. Просто создайте свою комнату и смотрите, общайтесь, обсуждайте.',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            customSignInDialog(
                              context,
                              onClosed: ((_) {
                                setState(() {
                                  isSignInDialogShown = false;
                                });
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
