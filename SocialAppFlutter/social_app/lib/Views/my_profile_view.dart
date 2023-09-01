import 'package:flutter/material.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1)
              ],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 38),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back_ios, color: Colors.white),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "My\nProfile",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: screenHeight * 0.4,
                    // color: Colors.black,
                    child: LayoutBuilder(builder: (context, constraints) {
                      double innerHeight = constraints.maxHeight;
                      double innerWidth = constraints.maxWidth;
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: innerHeight * 0.65,
                              width: innerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 70,),
                                  Text("Andrei Istrate",
                                  style: TextStyle(
                                    color: Color.fromRGBO(39, 105, 171, 1),
                                    fontFamily: 'Nunito',
                                    fontSize: 32
                                  ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Played",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: 'Nunito',
                                              fontSize: 21
                                            ),
                                          ),
                                          Text(
                                            "10",
                                            style: TextStyle(
                                              color: Color.fromRGBO(39, 105, 171, 1),
                                              fontFamily: 'Nunito',
                                              fontSize: 21
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25,
                                        vertical: 8),
                                        child: Container(
                                          width: 5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Honors",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: 'Nunito',
                                              fontSize: 21
                                            ),
                                          ),
                                          Text(
                                            "16",
                                            style: TextStyle(
                                              color: Color.fromRGBO(39, 105, 171, 1),
                                              fontFamily: 'Nunito',
                                              fontSize: 21
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                child: Image.asset(
                                  'assets/images/andrei.png',
                                  fit: BoxFit.fitWidth,
                                  width: innerWidth * 0.45,
                                ),
                                
                                ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: screenHeight * 0.5,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            "Admirers",
                            style: TextStyle(
                              color: Color.fromRGBO(39, 105, 171, 1),
                              fontSize: 25,
                              fontFamily: 'Nunito'
                            ),
                          ),
                          const Divider(thickness: 2.5,),
                          const SizedBox(height: 10,),
                          SingleChildScrollView(
                            child: SizedBox(
                              height: screenHeight * 0.35,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder:(context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
