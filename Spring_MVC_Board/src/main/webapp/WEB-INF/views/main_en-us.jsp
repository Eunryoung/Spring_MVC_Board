<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<!-- <link href="./css/default.css" rel="stylesheet" type="text/css"> -->
<%-- EL 을 활용하여 컨텍스트경로를 얻어와서 절대주소처럼 사용 가능 --%>
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
	<header>
		<!-- 기본메뉴 표시 영역(top.jsp 페이지 삽입) -->
		<%-- 주의! JSP 파일은 WEB-INF/views 디렉토리 내에 위치 --%>
		<jsp:include page="inc/top.jsp"></jsp:include>
	</header>
	<article>
		<!-- 본문 표시 영역 -->
		<h1>MVC Board</h1>
		<h3><a href="BoardWriteForm">Write</a></h3>
		<h3><a href="BoardList">Show List</a></h3>
	</article>
	<footer>
		<!-- 회사소개 표시 영역(bottom.jsp 페이지 삽입) -->
		<jsp:include page="./inc/bottom.jsp"></jsp:include>
		<select name="lang" onchange="location.href='${pageContext.request.contextPath }?lang=' + this.value">
			<option value="ko-kr"<c:if test="${param.lang eq 'ko-kr' }">selected</c:if>>Korean</option>
			<option value="en-us"<c:if test="${param.lang eq 'en-us' }">selected</c:if>>English</option>
		</select>
	</footer>
</body>
</html>














