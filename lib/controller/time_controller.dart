

class TimeController{
  int getCurrentTime(String format){
    int result=0;

    final String now = new DateTime.now().toString();

    switch(format){
      case "Y":
        result=int.parse(now.substring(0,4));
        break;
      case "M":
        result=int.parse(now.substring(5,7));
        break;
      case "D":
        result=int.parse(now.substring(8,10));
        break;
      case "H":
        result=int.parse(now.substring(11,13));
        break;
      case "m":
        result=int.parse(now.substring(14,16));
        break;
      case "S":
        result=int.parse(now.substring(17,19));
        break;
      case "Ms":
        result=int.parse(now.substring(20,22));
        break;

    }
    return result;
  }
}