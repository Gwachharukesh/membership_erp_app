import 'package:flutter/material.dart';
import 'fluid_card.dart';
import 'fluid_carousel.dart';

// NOTE: Agr apko ye onboarding screen use krni hain to ap nechy text ko change kr skty hain
class Showcase extends StatefulWidget {
  static const routeName = '/Showcase';
  const Showcase({super.key});


  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidCarousel(
        children: <Widget>[
          FluidCard(
            color: 'Red',
            altColor: Color(0xFF4259B2),
            title: "Start Your Day \nwith Peaceful Mornings",
            subtitle: "Wake up refreshed with calming nature-inspired sounds designed to ease you into the day.",
          ),
          FluidCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "Refresh Your Mind \nwith Guided Breathing",
            subtitle: "Reduce stress and boost focus with science-backed breathing techniques at your fingertips.",
          ),
          FluidCard(
            color: 'Blue',
            altColor: Color(0xFFFFB138),
            title: "Sleep Soundly \nwith Soothing Stories",
            subtitle: "Drift into deep sleep with a collection of relaxing bedtime stories and mindfulness exercises.",
          ),
        ],
      ),
    );
  }
}