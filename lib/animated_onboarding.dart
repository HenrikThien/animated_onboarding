library animated_onboarding;

import 'package:flutter/material.dart';

class AnimatedOnboarding extends StatefulWidget {
  final List<OnboardingPage> pages;
  final PageController pageController;
  final VoidCallback onFinishedButtonTap;
  final Widget topLeftChild;
  final Widget topRightChild;
  final MainAxisAlignment topMainAxisAlignment;

  const AnimatedOnboarding({
    @required this.pages,
    @required this.pageController,
    @required this.topLeftChild,
    @required this.topRightChild,
    @required this.onFinishedButtonTap,
    this.topMainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  _AnimatedOnboardingState createState() => _AnimatedOnboardingState();
}

class _AnimatedOnboardingState extends State<AnimatedOnboarding> {
  ValueNotifier<double> _notifier = ValueNotifier(0.025);
  final _button = GlobalKey();

  bool _lastPageIsVisible = false;

  @override
  void initState() {
    widget.pageController?.addListener(() {
      _notifier.value = widget.pageController.page + 0.025;

      if (widget.pageController.page == widget.pages.length - 1 && !_lastPageIsVisible) {
        setState(() => _lastPageIsVisible = true);
      }

      if (_lastPageIsVisible && widget.pageController.page != widget.pages.length - 1) {
        setState(() => _lastPageIsVisible = false);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.pageController?.dispose();
    _notifier?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _notifier,
            builder: (context, __) => CustomPaint(
              painter: _FlowPainter(
                context: context,
                notifier: _notifier,
                target: _button,
                colors: widget.pages.map((e) => e.color).toList(growable: false),
              ),
            ),
          ),
          PageView.builder(
            controller: widget.pageController,
            itemCount: widget.pages.length,
            itemBuilder: (c, i) => Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: _AnimatedBody(
                  child: widget.pages.elementAt(i).child,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: widget.topMainAxisAlignment,
                  children: <Widget>[
                    widget.topLeftChild,
                    if (_lastPageIsVisible)
                      FlatButton(
                        onPressed: () => widget.onFinishedButtonTap(),
                        child: Text(
                          "Finish",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (!_lastPageIsVisible) widget.topRightChild,
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!_lastPageIsVisible) {
                widget.pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
              } else {
                widget.onFinishedButtonTap();
              }
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 25),
                child: Material(
                  elevation: 4.0,
                  shadowColor: Colors.white,
                  shape: CircleBorder(),
                  child: ClipOval(
                    child: AnimatedBuilder(
                      animation: _notifier,
                      builder: (_, __) {
                        final animatorVal = _notifier.value - _notifier.value.floor();
                        double opacity = 0, iconPos = 0;
                        int colorIndex;
                        if (animatorVal < 0.5) {
                          opacity = (animatorVal - 0.5) * -2;
                          iconPos = 60 * -animatorVal;
                          colorIndex = _notifier.value.floor() + 1;
                        } else {
                          colorIndex = _notifier.value.floor() + 2;
                          iconPos = -60;
                        }
                        if (animatorVal > 0.9) {
                          iconPos = -250 * (1 - animatorVal) * 10;
                          opacity = (animatorVal - 0.9) * 10;
                        }
                        colorIndex = colorIndex % widget.pages.length;
                        return SizedBox(
                          key: _button,
                          width: 60,
                          height: 60,
                          child: Transform.translate(
                            offset: Offset(iconPos, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.navigate_next,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowPainter extends CustomPainter {
  final BuildContext context;
  final ValueNotifier<double> notifier;
  final GlobalKey target;
  final List<Color> colors;

  RenderBox _renderBox;

  _FlowPainter({this.context, this.notifier, this.target, this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final screen = MediaQuery.of(context).size;
    if (_renderBox == null && target != null) _renderBox = target.currentContext.findRenderObject();
    if (_renderBox == null || notifier == null) return;

    final page = notifier.value.floor();
    final animatorVal = notifier.value - page;
    final targetPos = _renderBox.localToGlobal(Offset.zero);
    final xScale = screen.height * 8;
    final yScale = xScale / 2;

    var curvedVal = Curves.easeInOut.transformInternal(animatorVal);
    final reverseVal = 1 - curvedVal;

    Paint nextColorPaint = Paint(), bgPaint = Paint();
    Rect buttonRect, bgRect = Rect.fromLTWH(0, 0, screen.width, screen.height);

    if (animatorVal < 0.6) {
      bgPaint..color = colors[page % colors.length];
      nextColorPaint..color = colors[(page + 1) % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPos.dx - (xScale * curvedVal), //left
        targetPos.dy - (yScale * curvedVal), //top
        targetPos.dx + _renderBox.size.width * reverseVal, //right
        targetPos.dy + _renderBox.size.height + (yScale * curvedVal), //bottom
      );
    } else {
      bgPaint..color = colors[(page + 1) % colors.length];
      nextColorPaint..color = colors[page % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPos.dx + _renderBox.size.width * reverseVal, //left
        targetPos.dy - yScale * reverseVal, //top
        targetPos.dx + _renderBox.size.width + xScale * reverseVal, //right
        targetPos.dy + _renderBox.size.height + yScale * reverseVal, //bottom
      );
    }

    canvas.drawRect(bgRect, bgPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, Radius.circular(screen.height)),
      nextColorPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _AnimatedBody extends StatefulWidget {
  final Widget child;
  const _AnimatedBody({@required this.child});

  @override
  _AnimatedBodyState createState() => _AnimatedBodyState();
}

class _AnimatedBodyState extends State<_AnimatedBody> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class OnboardingPage {
  final Color color;
  final Widget child;

  const OnboardingPage({@required this.color, @required this.child});
}
