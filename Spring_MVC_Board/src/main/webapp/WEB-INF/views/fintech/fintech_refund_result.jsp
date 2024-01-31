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
</head>
<body>
	<header>
		<!-- 기본메뉴 표시 영역(top.jsp 페이지 삽입) -->
		<%-- 주의! JSP 파일은 WEB-INF/views 디렉토리 내에 위치 --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<!-- 본문 표시 영역 -->
		<h1>핀테크 입금이체(환불) 결과</h1>
		<%-- depositResult 객체에 저장된 데이터 출력 --%>
		<table border="1">
			<tr>
				<th>입금은행명(기관코드)</th>
				<td>${depositResult.res_list[0].bank_name}(${depositResult.res_list[0].bank_code_std})</td>
			</tr>
			<tr>
				<th>입금일시</th>
				<td>${depositResult.api_tran_dtm}</td>
			</tr>
			<tr>
				<th>예금주명</th>
				<td>${depositResult.res_list[0].account_holder_name}</td>
			</tr>
			<tr>
				<th>입금금액</th>
				<td>${depositResult.res_list[0].tran_amt} 원</td>
			</tr>
			<tr>
				<th>입금계좌인자내역</th>
				<td>${depositResult.res_list[0].print_content}</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="돌아가기" onclick="history.back()">
				</td>
			</tr>
		</table>
	</article>
	<footer>
		<!-- 회사소개 표시 영역(bottom.jsp 페이지 삽입) -->
		<jsp:include page="../inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>














