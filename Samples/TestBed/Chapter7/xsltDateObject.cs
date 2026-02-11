namespace XsltTransformation.ExternalObjects {
    using System;

    public class XsltDateTime {
        DateTime _date;
        public XsltDateTime() {
            _date = DateTime.Now;
        }
        public DateTime GetDateTime() {
            return _date;
        }
    }
}
