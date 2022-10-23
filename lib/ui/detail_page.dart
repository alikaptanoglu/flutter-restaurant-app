import 'package:flutter/material.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/retaurant_detail';

  final String id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Restaurant Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (_) =>
            RestaurantDetailProvider(apiService: ApiService(), id: id),
        child: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(
                  child: CircularProgressIndicator(color: primaryTextColor));
            } else if (state.state == ResultState.hasData) {
              var restaurant = state.restaurantList.restaurant;
              return RestaurantDetailPage(restaurant: restaurant);
            } else {
              return const Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }
}

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(restaurant.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(restaurant.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("${restaurant.city} - ${restaurant.address}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                      overflow: TextOverflow.fade,
                    )),
                const SizedBox(height: 8),
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant.categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                            color: backgroundOutline,
                            width: 2,
                          )),
                        ),
                        child: Text(restaurant.categories[index].name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                            )),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(restaurant.description,
                    maxLines: 5,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildRestaurantPartTitle('Foods'),
          _buildMenuList(restaurant.menus.foods),
          const SizedBox(height: 32),
          _buildRestaurantPartTitle('Drinks'),
          _buildMenuList(restaurant.menus.drinks),
          const SizedBox(height: 32),
          _buildRestaurantPartTitle('Reviews'),
          SizedBox(
              height: 130,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: restaurant.customerReviews.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: defaultShadow.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.customerReviews[index].review,
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                          ),
                          Text("- ${restaurant.customerReviews[index].name}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

Widget _buildRestaurantPartTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildMenuList(var items) {
  return SizedBox(
      height: 32,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant),
                const SizedBox(width: 8),
                Text(items[index].name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ))
              ],
            ),
          );
        },
      ));
}
