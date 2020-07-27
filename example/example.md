# animated_onboarding example

```dart
  final _pages = [
    OnboardingPage(child: Text("Title1", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xffff1744)),
    OnboardingPage(child: Text("Title2", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xffff9100)),
    OnboardingPage(child: Text("Title3", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff00695c)),
    OnboardingPage(child: Text("Title4", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff5c6bc0)),
    OnboardingPage(child: Text("Title5", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), color: const Color(0xff37474f)),
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedOnboarding(
      pages: _pages,
      pageController: PageController(),
      onFinishedButtonTap: () {
        print("FINISHED!!");
      },
      topLeftChild: Text(
        "App Name",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      topRightChild: FlatButton(
        child: Text(
          "Skip",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }
```
