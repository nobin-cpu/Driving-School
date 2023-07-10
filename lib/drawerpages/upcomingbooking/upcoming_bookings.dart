import 'package:flutter/material.dart';

class UpcomingBooking extends StatefulWidget {
  const UpcomingBooking({Key? key}) : super(key: key);

  @override
  State<UpcomingBooking> createState() => _UpcomingBookingState();
}

class _UpcomingBookingState extends State<UpcomingBooking> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Container(
                      height: size.height * .14,
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .0,
                                  left: size.width * .06),
                              child: CircleAvatar(
                                maxRadius: size.height * .035,
                                backgroundColor: Color(0xFF198754),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.white,
                                  size: size.height * .04,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * .02,
                                      left: size.width * .07),
                                  child: Text(
                                    "22-Jun-2023",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFF198754),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * .015,
                                      left: size.width * .07),
                                  child: Text(
                                    "03-Jun-2023 to 03-Jun-2023",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }
}
