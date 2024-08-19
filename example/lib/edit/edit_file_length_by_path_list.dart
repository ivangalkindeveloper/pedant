// ignore_for_file: edit_file_length_by_path
// Fish body
import 'package:flutter/widgets.dart';

class Fish {
  const Fish({
    required this.name,
    required this.age,
    required this.length,
    required this.color,
  });

  final String name;
  final int age;
  final double length;
  final Color color;

  void swim() {}

  void eat() {}

  void sleep() {}
}

// Fish scales
class Scale {
  const Scale({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  void shine() {}
}

// Fish fin
class Fin {
  const Fin({
    required this.type,
    required this.size,
  });

  final String type;
  final double size;

  void flap() {}
}

// Fish tail
class Tail {
  const Tail({
    required this.shape,
    required this.size,
  });
  final String shape;
  final double size;

  void wag() {}
}

// Create a fish
void main() {
  const Fish fish = Fish(
    name: "Goldie",
    age: 5,
    length: 10.0,
    color: Color(
      0xFF0000FF,
    ),
  );

  // Create fish scales
  const List<Scale> scales = [
    Scale(
      color: Color(
        0xFF0000FF,
      ),
      size: 0.5,
    ),
    Scale(
      color: Color(
        0xFF0000FF,
      ),
      size: 0.5,
    ),
    Scale(
      color: Color(
        0xFF0000FF,
      ),
      size: 0.5,
    ),
  ];

  const Fin fin = Fin(
    type: "dorsal",
    size: 2.0,
  );

  // Create fish tail
  const Tail tail = Tail(
    shape: "forked",
    size: 3.0,
  );

  // Make the fish swim
  fish.swim();

  // Make the fish eat
  fish.eat();

  // Make the fish sleep
  fish.sleep();

  // Make the scales shine
  for (Scale scale in scales) {
    scale.shine();
  }

  // Make the fin flap
  fin.flap();

  // Make the tail wag
  tail.wag();
}
