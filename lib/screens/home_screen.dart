import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vilmart/screens/qr_screen.dart';
import '../bloc/form_bloc/data_fetch_status.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_event.dart';
import '../bloc/home_bloc/home_state.dart';
import '../bloc/product_category_bloc/store_category_bloc.dart';
import '../bloc/product_category_bloc/store_category_event.dart';
import '../data/repositories/home_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../data/repositories/product_category_repository.dart';
import '../widgets/loading_screen.dart';
import 'category/product_detail_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> categories = [
    {
      'title': 'Restaurant',
      'image': 'assets/images/Categories/cooking.png'
    },
    {
      'title': 'Groceries',
      'image': 'assets/images/Categories/grocery.png'
    },
    {
      'title': 'Electronics & Gadgets',
      'image': 'assets/images/Categories/gadgets.png'
    },
    {
      'title': 'Fashion & Apparel',
      'image': 'assets/images/Categories/wardrobe.png'
    },
    {
      'title': 'Home & Furniture',
      'image': 'assets/images/Categories/livingroom.png'
    },
    {
      'title': 'Health & Beauty',
      'image': 'assets/images/Categories/skin-care.png'
    },
    {
      'title': 'Books & Stationery',
      'image': 'assets/images/Categories/stationery.png'
    },
    {
      'title': 'Sports & Outdoors',
      'image': 'assets/images/Categories/badminton.png'
    },
  ];

  String _locationMessage = "Fetching location...";

  final FlutterSecureStorage secureStorage=FlutterSecureStorage();
  @override

  void initState() {
    super.initState();
    _getCurrentLocation();
    _getUserData();
  }

  List<String> userData = [];


  Future<void> _getUserData() async {
    String? userName = await secureStorage.read(key: 'userName');
    String? shopId = await secureStorage.read(key: 'shopId');
    print('userName:${userName}');
    if (userName != null) {
      setState(() {
        userData.add(userName);
      });
      print('userName:${userData[0]}');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = "Location services are disabled.";
        });
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = "Location permissions are permanently denied.";
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Debug print coordinates
      debugPrint('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      // Convert to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        setState(() {
          _locationMessage = "${place.locality}";
        });
      } else {
        setState(() {
          _locationMessage = "No address found.";
        });
      }
    } catch (e, stackTrace) {
      debugPrint("Exception occurred: $e\n$stackTrace"); // Full stack trace for debugging
      setState(() {
        _locationMessage = "Error fetching location: ${e.toString()}";
      });
    }
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(homeRepository: context.read<HomeRepository>())..add(HomePageLoad()),

        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state){
            if (state.status is DataFetchLoading) {
              return const LoadingScreen();
            }
            // if (state.status is DataFetchSuccess) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    surfaceTintColor: Colors.white,
                    leading: IconButton(onPressed: (){}, icon: const Icon(Icons.grid_view_rounded,size: 30,color: Colors.black,)),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final scannedCode = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QRViewScreen()),
                            );

                            if (scannedCode != null) {
                              // Do something with the scanned result
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Scanned: $scannedCode')),
                              );
                            }
                          },
                          icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.black),
                        ),

                        SizedBox(width: 20),
                        Center(
                          child: PopupMenuButton<String>(
                            offset: const Offset(0, 50),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) async {
                              switch (value) {
                                case 'store':
                                  context.push('/store');
                                  break;
                                case 'product':
                                  context.push('/product');
                                  break;
                                case 'qr':
                                  context.push('/qr');
                                  break;
                                case 'logout':
                                  context.go('/');
                                  await secureStorage.deleteAll();
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'store',
                                child: ListTile(
                                  leading: Icon(Icons.store),
                                  title: Text('Add Store'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'product',
                                child: ListTile(
                                  leading: Icon(Icons.shopping_bag),
                                  title: Text('Add Products'),
                                ),
                              ),
                              const PopupMenuDivider(height: 0),
                              const PopupMenuItem(
                                  value: 'qr',
                                child: ListTile(
                                  leading: Icon(Icons.qr_code_outlined),
                                  title: Text('Generate QR'),
                                ),
                              ),
                              const PopupMenuDivider(height: 0),
                              const PopupMenuItem(
                                value: 'logout',
                                child: ListTile(
                                  leading: Icon(Icons.logout, color: Colors.red),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                userData[0].isNotEmpty ? userData[0][0].toUpperCase() : '',
                                style: const TextStyle(
                                  fontSize:17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ]

                  ),
                  body:BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state.status is DataFetchFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error")),
                    );
                  }
                  if (state.status is DataFetchSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Product fetched"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                  child: SingleChildScrollView(
                    child: Container(
                      child: Padding(
                          padding:EdgeInsets.all(20),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Find all Products",style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),),
                          Text("around you.",style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 51,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: (_locationMessage == "Fetching location...")
                                            ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 5),
                                        )
                                            : const Icon(Icons.location_on, color: Colors.red),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _locationMessage,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width:5),
                              Expanded(
                                flex: 5,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: Icon(Icons.search_outlined),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.tune_rounded),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: double.infinity,
                            height: 150, // Adjust height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/ad.png'
                              ,  fit: BoxFit.cover ),
                          ),
                          SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    return Container(
                                      width: 80,
                                      margin: EdgeInsets.only(right: 16),
                                      child: Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () =>context.push('/category/$index/$_locationMessage'),
                                            padding: EdgeInsets.zero,
                                            shape: const CircleBorder(),
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.grey[200],
                                              ),
                                              child: ClipRRect(

                                                borderRadius: BorderRadius.circular(30),
                                                child: Container(
                                                  margin:EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    category['image']!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            category['title']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const Text('Top Item',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(5),
                            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: state.productData.length,
                            itemBuilder: (context,index){
                              final product = state.productData[index];
                              final imageUrl = product.productImages?.trim() ?? '';

                              return MaterialButton(
                                onPressed: () {
                                  final shopId = product.shopId;
                                  if (shopId == null || shopId.isEmpty) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => ProductCategoryBloc(
                                          categoryRepo: context.read<ProductCategoryRepository>(),
                                        )..add(FetchProduct(shopId: shopId)),
                                        child: ProductDetailPage(
                                          productId: product.productId,
                                          shopId: shopId,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                               padding: EdgeInsets.zero,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                                          child: Image.network(
                                            imageUrl,
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.image_not_supported, size: 50);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.productName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              const SizedBox(height: 4),

                                              // Category
                                              Text(
                                                'Category: ${product.productCategory}',
                                                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              const SizedBox(height: 4),

                                              // Price & Availability
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₹${product.price}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  Text(
                                                    product.availabilityStatus,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: [
                                                        'in stock',
                                                        'available',
                                                      ].contains(product.availabilityStatus.toLowerCase())
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 4),

                                              // Rating
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Rating:',
                                                    style: TextStyle(fontSize: 12, color: Colors.orange),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  // Full stars
                                                  for (int i = 0; i < product.productRating.toInt(); i++)
                                                    const Icon(Icons.star, color: Colors.orange, size: 14),
                                                  // Empty stars
                                                  for (int i = 0; i < (5 - product.productRating.toInt() - (product.productRating % 1 != 0 ? 1 : 0)); i++)
                                                    const Icon(Icons.star_border, color: Colors.orange, size: 14),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )

                        ],
                      )
                      ),
                    ),
                  ),
                  ),
                );

              }

          ),

    );
  }
}
