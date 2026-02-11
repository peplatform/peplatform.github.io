<%@ WebService Language="C#" class="Greeting" %>
using System.Web.Services;

[WebService(Namespace="http://www.TomorrowsLearning.com/Greeting")]
class Greeting: WebService {
	[WebMethod]
	public string Greet(string name) {
		return "Hi " + name + "!";
	}
	[WebMethod(MessageName="GreetVerbose")]
	public string Greet(string fname,string lname) {
		return "Hi " + fname + " " + lname + "!";
	}
}
