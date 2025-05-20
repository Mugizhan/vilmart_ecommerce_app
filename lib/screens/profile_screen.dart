import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/profile_model/profile_model.dart';
import '../bloc/add_to_cart/add_to_cart_bloc.dart';
import '../bloc/add_to_cart/add_to_cart_event.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 50,
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is ProfileLoaded) {
            final user = state.profileData.userProfile;
            final shops = state.profileData.userShops;

            return ListView(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(shops.first.shopImageLink,),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '👤',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("👤 Name: ${user.name}", style: const TextStyle(fontSize: 16)),
                Text("📧 Email: ${user.email}", style: const TextStyle(fontSize: 16)),
                Text("📱 Phone: ${user.phoneNumber}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text("🏪 Shops:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...shops.map((shop) => Card(
                  child: ListTile(
                    title: Text(shop.shopName),
                    subtitle: Text("Rating: ${shop.rating}"),
                  ),
                )),
              ],
            );
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }
}
