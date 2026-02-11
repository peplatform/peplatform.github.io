<%@ WebService Language="C#" class="Counter"%>
using System;
using System.Web.Services;

[WebService(Namespace="http://www.TomorrowsLearning.com/Counter")]
public class Counter : WebService {

     [WebMethod(EnableSession=true)]
     public int UpdateSessionCounter() {
          if (Session["HitCounter"] == null) {
              Session["HitCounter"] = 0;
          }
          else {
              Session["HitCounter"] = ((int) Session["HitCounter"]) + 1;
          }
          return Convert.ToInt32(Session["HitCounter"]);
     }
} 

