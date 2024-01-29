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
		<h1>핀테크 계좌 상세정보</h1>
		<%-- accountDetail 객체에 저장된 데이터 출력 --%>
		<h3>${user_name } 고객님의 계좌 상세정보 (사용자번호 : ${sessionScope.user_seq_no})</h3>
<%-- 		${accountDetail} --%>
		<table border="1">
			<tr>
				<th>은행명</th>
				<td>${accountDetail.bank_name }</td>
			</tr>
			<tr>
				<th>계좌번호</th>
				<td>${account_num_masked }</td>
			</tr>
			<tr>
				<th>상품명</th>
				<td>${accountDetail.product_name }</td>
			</tr>
			<tr>
				<th>계좌잔고</th>
				<td>${accountDetail.balance_amt } 원</td>
			</tr>
			<tr>
				<th>출금가능금액</th>
				<td>${accountDetail.available_amt } 원</td>
			</tr>
			<tr>
				<th>핀테크이용번호</th>
				<td>${accountDetail.fintech_use_num }</td>
			</tr>
			<tr>
				<td colspan="2">
					<%-- 출금이체용 form 태그 생성 --%>
					<%-- 사용자 핀테크이용번호, 요청고객성명, 거래금액 전달 --%>
					<form action="BankPayment" method="post">
						<input type="hidden" name="fintech_use_num" value="${accountDetail.fintech_use_num }">						
						<input type="hidden" name="req_client_name" value="${user_name }">						
						<input type="hidden" name="tran_amt" value="15000">						
						<input type="submit" value="상품구매(결제)">
					</form>
					<form action="BankRefund" method="post">
						<input type="hidden" name="fintech_use_num" value="${accountDetail.fintech_use_num }">						
						<input type="hidden" name="req_client_name" value="${user_name }">						
						<input type="hidden" name="tran_amt" value="5014">						
						<input type="submit" value="상품구매취소(환불)">
					</form>
					<form action="BankTransfer" method="post">
						<input type="hidden" name="fintech_use_num" value="${accountDetail.fintech_use_num }">						
						<input type="hidden" name="req_client_name" value="${user_name }">						
						<input type="hidden" name="tran_amt" value="5114">	
						<input type="text" name="recv_client_fintech_use_num" value="상대방핀테크이용번호">	
						<input type="text" name="recv_client_account_num" value="상대방계좌번호">	
						<input type="text" name="recv_client_bank_code" value="상대방은행코드">	
						<input type="text" name="recv_client_name" value="상대방예금주명">	
						<input type="submit" value="송금">
					</form>
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














