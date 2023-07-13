import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xFF1D1D1D),
        highlightColor: const Color(0XFF3C4042),
        enabled: true,
        child: ListView.builder(
          itemBuilder: (context, index) => const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Material(color: Colors.transparent),
                subtitle: Material(
                  color: Colors.transparent,
                ),
                trailing: Material(),
                leading: Material(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          itemCount: 5,
        ));
  }
}
