<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko-KR">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<title>환율 계산</title>
</head>
<body>

<div>
	<h1>
		환율 계산
	</h1>
	
	<select name="remittance_country">
		<option value="">송금국가를 선택하세요.</option>
		<option value="USD">미국(USD)</option>
		<option value="AUD">호주(AUD))</option>
	</select>
	
	<select name="recipient_country">
		<option value=""></option>
	</select>
</div>

</body>
</html>
