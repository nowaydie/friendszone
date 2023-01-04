import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController GetRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void SignIn(BuildContext) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          check.fire();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();
          });
        } else {
          error.fire();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style: TextStyle(color: Colors.white54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (email) {},
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset("assets/icons/email.svg"),
                  )),
                ),
              ),
              const Text(
                "Пароль",
                style: TextStyle(color: Colors.white54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (password) {},
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset("assets/icons/password.svg"),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                    onPressed: () {
                      SignIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.arrow_right),
                    label: const Text("Sign in")),
              )
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  onInit: (artboard) {
                    StateMachineController controller =
                        GetRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger;
                    error = controller.findSMI("Error") as SMITrigger;
                    reset = controller.findSMI("Reset") as SMITrigger;
                  },
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                  scale: 7,
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/confetti.riv",
                    onInit: (artboard) {
                      StateMachineController controller =
                          GetRiveController(artboard);

                      confetti =
                          controller.findSMI("Trigger explosion") as SMITrigger;
                    },
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({Key? key, required this.child, this.size = 100})
      : super(key: key);

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
