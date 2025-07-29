// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:triptango/core/models/trip_model.dart';
import 'dart:ui';

class FeaturedTripCard extends StatelessWidget {
  final TripModel trip;

  const FeaturedTripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Add tap functionality if needed
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), // Reduced vertical margin
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12), // Reduced padding to save space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Ensure column takes only needed space
                  children: [
                    // Image container with fixed height
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: trip.coverImageUrl != null
                            ? Image.network(
                                trip.coverImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300]?.withOpacity(0.5),
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[300]?.withOpacity(0.5),
                                child: const Icon(
                                  Icons.image,
                                  size: 48,
                                  color: Colors.white70,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced spacing
                    // Title with Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        trip.title ?? 'Trip Title',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6), // Reduced spacing
                    // Description with Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        trip.description ?? 'Trip Description',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              height: 1.3,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}