import 'dart:async';
import 'package:flutter/material.dart';
import 'package:service_sphere/Login.dart';
import 'package:service_sphere/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Color(0xFFFD746C),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://th.bing.com/th/id/OIP.U9DZtGTQ463iWko7J-WnuAHaFn?cb=iwc2&rs=1&pid=ImgDetMain',
    'https://th.bing.com/th/id/OIP.-b8IZVku5z1Uw9faOvOEAwHaFN?cb=iwc2&rs=1&pid=ImgDetMain',
    'https://static.vecteezy.com/system/resources/thumbnails/024/316/081/small_2x/water-delivery-service-big-bottle-with-clean-water-supply-shipping-modern-flat-cartoon-style-illustration-on-white-background-vector.jpg',
    'https://th.bing.com/th/id/OIP.JLEILd7-LZajP1eKTdiI7AHaFN?cb=iwc2&rs=1&pid=ImgDetMain'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text("Service Sphere", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF22303b),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          AutoScrollingCarousel(imageUrls: imageUrls),
        ],
      ),
    );
  }
}

// -------------------- Reusable Carousel Class --------------------
class AutoScrollingCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const AutoScrollingCarousel({
    Key? key,
    required this.imageUrls,
    this.height = 200,
  }) : super(key: key);

  @override
  _AutoScrollingCarouselState createState() => _AutoScrollingCarouselState();
}

class _AutoScrollingCarouselState extends State<AutoScrollingCarousel> {
  late List<String> _carouselImages;
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselImages = List.from(widget.imageUrls)..add(widget.imageUrls[0]);
    _pageController = PageController(viewportFraction: 0.9);

    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        if (_currentPage == _carouselImages.length - 1) {
          Future.delayed(Duration(milliseconds: 600), () {
            _pageController.jumpToPage(0);
            _currentPage = 0;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _carouselImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _carouselImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}
