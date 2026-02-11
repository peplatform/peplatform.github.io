<script language="c#" runat="server">
    public void submitButton_Click(Object Src, EventArgs E) { 
        Greeting.Greeting objGreet = new Greeting.Greeting();        
        wsResults.InnerHtml = objGreet.Greet(myName.Value);
    }
</script>
<html>
	<head>
		<title>
			Hitting the Greeting Web Service From an ASP+ Page
		</title>
	</head>
	<body bgcolor="#ffffff">
		<form runat="server">
			<b>Enter your Name:</b>&nbsp;&nbsp;
			<input type="text" name="myName" id="myName" runat="server" />
			<input type="button" id="submitButton" value="Hit the Web Service!" onServerClick="submitButton_Click" runat="server" />
			<p>
				<b>Value returned from Greeting Web Service:</b>
			<p />
			<div id="wsResults" style="width:300px;background:#efefef;color:#ff0000;font-weight:bold;font-size:18pt;" runat="server" />
		</form>
	</body>
</html>
