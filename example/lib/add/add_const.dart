// class ConstClass {
//   const ConstClass({
//     required this.age,
//   });

//   final int? age;
// }

// // // ---

// const int globalVar = 0;

// const int anotherVar = globalVar;

// const ConstClass topLevelConst = ConstClass(
//   age: globalVar,
// );

// void b() {
//   const ConstClass(
//     age: anotherVar,
//   );

//   const int a = 0;
//   const ConstClass constVariable = ConstClass(
//     age: 20,
//   );
// }

// const List<ConstClass> a = [
//   ConstClass(
//     age: 12,
//   ),
// ];
