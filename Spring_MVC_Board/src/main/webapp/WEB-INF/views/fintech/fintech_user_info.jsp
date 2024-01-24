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
<script>
</script>
</head>
<body>
	<header>
		<!-- 기본메뉴 표시 영역(top.jsp 페이지 삽입) -->
		<%-- 주의! JSP 파일은 WEB-INF/views 디렉토리 내에 위치 --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<!-- 본문 표시 영역 -->
<%-- 		액세스토큰 : ${access_token }<br> --%>
<%-- 		사용자번호 : ${user_seq_no }<br> --%>
<%-- 		사용자정보 : ${userInfo } --%>
		<h1>핀테크 사용자 정보</h1>
		<%-- userInfo 객체에 저장된 데이터 출력 --%>
		<h3>${userInfo.user_name } 고객님의 정보(사용자번호 : ${userInfo.user_seq_no })</h3>
		<h3>총 계좌 수 : ${userInfo.res_cnt } 개</h3>
		<table border="1">
			<tr>
				<th>계좌별명</th>
				<th>계좌번호</th> <%-- 마스킹 된 계좌번호 표시 --%>
				<th>은행명(은행코드)</th>
				<th>예금주명</th>
				<th>핀테크이용번호</th>
				<th></th>
			</tr>
			<%-- userInfo 객체의 res_list 객체를 반복하여 각 계좌에 접근 가능 --%>
			<c:forEach var="list" items="${userInfo.res_list }">
				<tr>
					<td>${list.account_alias }</td>				
					<td>${list.account_num_masked }</td>				
					<td>${list.bank_name }(${list.bank_code_std })</td>				
					<td>${list.account_holder_name }</td>				
					<td>${list.fintech_use_num }</td>				
					<td>
						<%-- 2.3.1. 잔액조회 API 서비스 요청을 위한 데이터 전송 폼 생성(계좌 당 1개) --%>
						<%-- 요청 URL : BankAccountDetail, 요청 방식 : POST --%>
						<%-- 파라미터 : 핀테크이용번호, 예금주명, 계좌번호(마스킹) --%>
						<form action="BankAccountDetail" method="post">
							<input type="hidden" name="fintech_use_num" value="${list.fintech_use_num }">							
							<input type="hidden" name="account_holder_name" value="${list.account_holder_name }">							
							<input type="hidden" name="account_num_masked" value="${list.account_num_masked }">							
							<input type="hidden" name="user_name" value="${userInfo.user_name }">							
							<input type="submit" value="상세정보">
						</form>
					</td>				
				</tr>
			</c:forEach>
		</table>
	</article>
	<footer>
		<!-- 회사소개 표시 영역(bottom.jsp 페이지 삽입) -->
		<jsp:include page="../inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>














