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
    final Size screenSize = MediaQuery.of(context).size;
    final double ScreenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text("Service Sphere", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF22303b),
      ),
      body: Column(
        children: [
          SizedBox(height: ScreenHeight * 0.02),
          AutoScrollingCarousel(imageUrls: imageUrls),
          SizedBox(height: ScreenHeight * 0.02),
          MainContent(),
        ],
      ),
    );
  }
}

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
class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Hub",
            style: TextStyle(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Water Service Card
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: screenWidth * 0.40,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Text column aligned top-left
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Water Service',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Water Supply, Water Leak Repair, Water Testing',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Image positioned bottom right
                          Positioned(
                            bottom: -10,
                            right: -8,
                            child: Container(
                              height: 55,
                              width: 55,
                              child: Image.asset(
                                'assets/Images/waterimage.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Two stacked empty boxes
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Text column aligned top-left
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Car Service',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Car Repair, Car Wash',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Image positioned bottom right
                              Positioned(
                                bottom: -6,
                                right: -4,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(
                                    'assets/Images/car Image.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Text column aligned top-left
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Solar Service',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Solar Repair, Solar Fix',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Image positioned bottom right
                              Positioned(
                                bottom: -6,
                                right: -4,
                                child: Container(
                                  height: 33,
                                  width: 33,
                                  child: Image.asset(
                                    'assets/Images/solar Image.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    )
                  ],
                ),

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Text column aligned top-left
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Electric Service',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Electric Repair, Electric Install',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Image positioned bottom right
                    Positioned(
                      bottom: -6,
                      right: -4,
                      child: Container(
                        height: 45,
                        width: 45,
                        child: Image.asset(
                          'assets/Images/Electric Image.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],

      ),

    );
  }
}

