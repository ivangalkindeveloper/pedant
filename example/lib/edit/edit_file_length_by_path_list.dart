// // Fish body
// import 'package:flutter/widgets.dart';

// class Fish {
//   String _name;
//   int _age;
//   double _length;
//   Color _color;

//   Fish(
//     this._name,
//     this._age,
//     this._length,
//     this._color,
//   );

//   void swim() => print(
//         "$_name is swimming...",
//       );

//   void eat() => print(
//         "$_name is eating...",
//       );

//   void sleep() => print(
//         "$_name is sleeping...",
//       );
// }

// // Fish scales
// class Scale {
//   Color _color;
//   double _size;

//   Scale(
//     this._color,
//     this._size,
//   );

//   void shine() => print(
//         "Scale is shining...",
//       );
// }

// // Fish fin
// class Fin {
//   double _size;
//   String _type;

//   Fin(
//     this._size,
//     this._type,
//   );

//   void flap() => print(
//         "Fin is flapping...",
//       );
// }

// // Fish tail
// class Tail {
//   double _size;
//   String _shape;

//   Tail(
//     this._size,
//     this._shape,
//   );

//   void wag() => print(
//         "Tail is wagging...",
//       );
// }

// // Create a fish
// void main() {
//   Fish fish = Fish("Goldie", 5, 10.0, Color(0xFF0000FF));

//   // Create fish scales
//   List<Scale> scales = [
//     Scale(Color(0xFF0000FF), 0.5),
//     Scale(Color(0xFF0000FF), 0.5),
//     Scale(Color(0xFF0000FF), 0.5),
//   ];

//   // Create fish fin
//   Fin fin = Fin(2.0, "dorsal");

//   // Create fish tail
//   Tail tail = Tail(3.0, "forked");

//   // Make the fish swim
//   fish.swim();

//   // Make the fish eat
//   fish.eat();

//   // Make the fish sleep
//   fish.sleep();

//   // Make the scales shine
//   for (Scale scale in scales) {
//     scale.shine();
//   }

//   // Make the fin flap
//   fin.flap();

//   // Make the tail wag
//   tail.wag();
// }
