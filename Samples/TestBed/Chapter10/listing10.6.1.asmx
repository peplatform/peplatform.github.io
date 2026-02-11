<%@ WebService Language="C#" class="Greeting" %>
using System.Web.Services;

[WebService(Namespace="http://www.TomorrowsLearning.com/Greeting",
            Description="This Web Service responds by saying 'Hi'")]
class Greeting: WebService {
    [WebMethod(Description="This method says 'Hi' and appends the input " +
                           "param to the response")]
    public string Greet(string name) {
        return "Hi " + name + "!";
    }
}



