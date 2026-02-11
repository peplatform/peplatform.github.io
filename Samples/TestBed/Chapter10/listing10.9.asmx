<%@ WebService Language="C#" class="Counter"%>
using System;
using System.Web.Services;

[WebService(Namespace="http://www.TomorrowsLearning.com/Counter")]
public class Counter : WebService {
     [WebMethod]
     public int UpdateAppCounter() {
          if (Application["HitCounter"] == null) {
              Application["HitCounter"] = 0;
          }
          else {
			  Application.Lock();
              Application["HitCounter"] = ((int) Application["HitCounter"]) + 1;
              Application.UnLock();
          }
          return Convert.ToInt32(Application["HitCounter"]);
     }
} 

