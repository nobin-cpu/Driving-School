class Appurl {
  static const String baseURL = "https://precisiondriving.uk/";
  static const String homes = baseURL + "api/home?requestingFor=contents";
  static const String homescarous =
      baseURL + "api/home?requestingFor=testimonials";
  static const String courses = baseURL + "api/home?requestingFor=courses";
  static const String login = baseURL + "api/login";
  static const String signup = baseURL + "api/signup";
  static const String instructors =
      baseURL + "api/home?requestingFor=instructors";

  static const String step1 = baseURL + "api/book-a-lesson/step/1";
  static const String step3 = baseURL + "api/book-a-lesson/step/3";
  static const String sentDate = baseURL + "api/book-a-lesson/step/2";
  static const String getTime = baseURL + "api/available-time";
  static const String stripepay = baseURL + "api/book-a-lesson/step/4";
  static const String senttotaltime = baseURL + "api/booked/schedule/store";
  static const String profile = baseURL + "api/profile";
  static const String deleteaccount = baseURL + "api/delete/my-profile";
  static const String help = baseURL + "api/help_-support";
  static const String dashoard = baseURL + "api/dashboard";
  static const String ongoing = baseURL + "api/bookings/show/ongoing";
  static const String ongoing2 = baseURL + "api/booking/details/";
  static const String calender = baseURL + "api/calendar";
  static const String completed = baseURL + "api/bookings/show/completed";
  static const String cancelBooking = baseURL + "api/bookings/status/cancel";
  static const String completedBooking =
      baseURL + "api/bookings/status/complete";
  static const String updatebasicInfo = baseURL + "api/profile/basic-info";
  static const String updateBio = baseURL + "api/profile/bio";
  static const String updateschedule = baseURL + "api/available-time/update";
  static const String carinfoUpdate = baseURL + "api/profile/car-info";
  static const String timeScheduleUpdate = baseURL + "api/profile/schedule";
  static const String updatePassword = baseURL + "api/profile/password";
  static const String availavleTimes = baseURL + "api/profile/schedule/get";
  static const String events = baseURL + "api/calendar";
  static const String allLearners = baseURL + "api/learners";
  static const String createLearners = baseURL + "api/learner/store";
  static const String createCourseLearners =
      baseURL + "api/booking/init/learner";
  static const String createTicket = baseURL + "api/support/ticket";
  static const String getTicketList = baseURL + "api/support/ticket";
}
