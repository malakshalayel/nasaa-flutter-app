import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nasaa/features/home/data/models/coch_details_response.dart';

class CoachDetailsScreen extends StatelessWidget {
  const CoachDetailsScreen({super.key, required this.coachDetails});
  final CoachDetails coachDetails;

  @override
  Widget build(BuildContext context) {
    print(coachDetails.idImage?.url);
    log('CoachDetailsScreen build with coach: ${coachDetails.name}');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            backgroundColor: const Color(0xFFF5F1ED),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),

          //content
          SliverList(
            delegate: SliverChildListDelegate([
              _buildProfileSection(),
              //const SizedBox(height: ),
              _buildMyActivitiesSection(),
              const SizedBox(height: 24),
              _buildAboutSection(),
              SizedBox(height: 24),
              _buildTrainingLocationSection(),
              // Add more sections as needed
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Profile Image with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFB68B59), width: 3),
                  image: DecorationImage(
                    image: NetworkImage(
                      coachDetails.idImage?.url ??
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5E34),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCD7F32),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Bronze',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            coachDetails.name ?? 'un named',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2E0F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyActivitiesSection() {
    return coachDetails.activities == null || coachDetails.activities!.isEmpty
        ? Container(
            padding: EdgeInsets.all(10),
            child: Text('No activity yet', style: TextStyle(color: Colors.red)),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'My Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A2E0F),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,

                child: ListView.builder(
                  itemCount: coachDetails.activities?.length ?? 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final activity = coachDetails.activities![index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: _buildActivityCard(
                        icon: Icons.fitness_center,
                        title: activity.name ?? 'Activity',
                        subtitle: activity.yearsOfExperience ?? 'Experience',
                        rating: activity.ratingAvg != null
                            ? activity.ratingAvg.toString()
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? rating,
  }) {
    return coachDetails.activities == null
        ? Container()
        : Container(
            width: 300,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F1ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 24, color: const Color(0xFF4A2E0F)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A2E0F),
                            ),
                          ),
                          if (rating != null) ...[
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFFFA500),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A2E0F),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF8B5E34),
                ),
              ],
            ),
          );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A2E0F),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[700],
              ),
              children: const [
                TextSpan(
                  text:
                      'Lorem Ipsum is simply dummy Lorem Ipsum is Lorem Lorem Ipsum is simply dummy Lorem ipsum dolor sit amet, amet Lorem Ipsum is simply dummy Lorem ',
                ),
                TextSpan(
                  text: 'Read More',
                  style: TextStyle(
                    color: Color(0xFF8B5E34),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Training Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A2E0F),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _buildLocationChip(
                  icon: Icons.wifi,
                  label:
                      coachDetails.trainingLocations![index].type ?? 'No type',
                );
              },
              itemCount: coachDetails.trainingLocations?.length ?? 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          // Row(
          //   children: [
          //     _buildLocationChip(icon: Icons.wifi, label: 'Online'),
          //     const SizedBox(width: 8),
          //     _buildLocationChip(
          //       icon: Icons.location_on,
          //       label: coachDetails.trainingLocations![].type?? 'Unknown',
          //     ),
          //   ],
          // ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F1ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 20,
                    color: Color(0xFF8B5E34),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Coach facility: Building 32, Waab Area, Doha, Qatar',
                    style: TextStyle(fontSize: 13, color: Color(0xFF4A2E0F)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChip({required IconData icon, required String label}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF8B5E34)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A2E0F),
            ),
          ),
        ],
      ),
    );
  }
}
