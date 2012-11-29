<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.*" %>

<% 
	String message = "";
	/* Create string of connection url within specified format with machine name, 
	port number and database name. Here machine name id localhost and 
	database name is usermaster. */ 
	String connectionURL = "jdbc:mysql://localhost:3306/CBSA"; 
	
	// declare a connection by using Connection interface 
	Connection connection = null; 
	
	// Load JBBC driver "com.mysql.jdbc.Driver" 
	Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		
	try {
		/* Create a connection by using getConnection() method that takes parameters of 
		string type connection url, user name and password to connect to database. */ 
		connection = DriverManager.getConnection(connectionURL, "root", "");
		
		// check weather connection is established or not by isClosed() method 
		if(connection.isClosed())
		{
			throw new Exception();
		}
		
		// deletes any metrics that exist by the given name
		String delete = "DELETE from `cbsa`.`performancemetric` WHERE `performancemetric`.`Name` = '" + request.getParameter("name").replaceAll(" ", "") + "' AND `performancemetric`.`Equation` <> 'System Defined' AND `performancemetric`.`Equation` <> 'Based on a Model'";
		PreparedStatement removeDups = connection.prepareStatement(delete);
		removeDups.executeUpdate();
		
		String insert = "INSERT INTO  `performancemetric` (  `MetricID` ,  `isDefault` ,  `Name` ,  `Statistic` ,  `Description` ,  `Equation` ,  `Type` )" 
				+ " VALUES ( NULL ,  '0',  '" + request.getParameter("name").replaceAll(" ", "") + "', '"+request.getParameter("statistic1")+"',  '" + request.getParameter("description") + "',  'System Defined',  'System Defined' )";
		PreparedStatement statement = connection.prepareStatement(insert);
		statement.executeUpdate();
		
		if(statement.getUpdateCount() == 1)
		{
			message = "The metric was successfully created.";
		}
		
		statement.close();
		
	}
	catch(Exception ex)
	{
		message = "Unable to connect to database.";
		out.println("Unable to connect to database. </br>" + ex.getMessage());
	}
	finally {
		if (connection != null) {
			try {
				connection.close();
			} catch (Exception e) {
			}
		}
	}
	
	String redirectURL = "../PerformanceMetrics.jsp?message=" + message;
	response.sendRedirect(redirectURL);
%>
