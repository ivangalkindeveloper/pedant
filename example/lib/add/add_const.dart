// class ConstClass {
//   final String subTitle = "asadsd";

//   const ConstClass({
//     this.nonConst,
//     required this.title,
//     required this.age,
//   });

//   final NonConstClass? nonConst;
//   final String title;
//   final int age;

//   void say() {}
// }

// class NonConstClass {
//   NonConstClass({
//     this.title,
//   });

//   String? title;
// }

// // ---

// const int a = 0;

// const ConstClass topLevelConst = ConstClass(
//   title: "title",
//   age: 18,
// );

// void b() {
//   const ConstClass(
//     title: "title",
//     age: 18,
//   );

//   const int a = 0;
//   const ConstClass constVariable = ConstClass(
//     title: "asd",
//     age: 20,
//   );
// }
