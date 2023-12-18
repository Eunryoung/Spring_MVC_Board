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
<style type="text/css">
	#member_list {
		width: 800px;
/* 		height: 600px; */
		border: 1px solid black;
	}
	
	#member_list th, td {
		text-align: center;
		border: 1px solid black;
	}
	
	.member_status_normal {
		color: blue;
	}
	.member_status_rest {
		color: orange;
	}
	.member_status_withdraw {
		color: gray;
	}
</style>
</head>
<body>
	<header>
		<!-- 기본메뉴 표시 영역(top.jsp 페이지 삽입) -->
		<%-- 주의! JSP 파일은 WEB-INF/views 디렉토리 내에 위치 --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<!-- 본문 표시 영역 -->
		<h1>관리자 페이지 - 회원목록조회</h1>
		<table id="member_list">
			<tr>
				<th width="50">번호</th>
				<th width="120">아이디</th>
				<th width="100">이름</th>
				<th width="200">이메일</th>
				<th width="120">가입일</th>
				<th width="100">회원상태</th>
				<th></th>
			</tr>
			<%-- 회원 목록 출력 --%>
			<c:forEach var="member" items="#{memberList}">
				<tr>
					<td>${member.idx}</td>
					<td>${member.id}</td>
					<td>${member.name}</td>
					<td>${member.email}</td>
					<td>${member.reg_date}</td>
					<%-- member_status 값에 따라 정수 대신 문자열로 표시(1 : 정상, 2 : 휴면, 3 : 탈퇴) --%>
<!-- 					<td> -->
<%-- 						<c:choose> --%>
<%-- 							<c:when test="${member.member_status eq 1}">정상</c:when> --%>
<%-- 							<c:when test="${member.member_status eq 2}">휴면</c:when> --%>
<%-- 							<c:when test="${member.member_status eq 3}">탈퇴</c:when> --%>
<%-- 						</c:choose> --%>
<!-- 					</td> -->
						<c:choose>
							<c:when test="${member.member_status eq 1}"><td class="member_status_normal">정상</td></c:when>
							<c:when test="${member.member_status eq 2}"><td class="member_status_rest">휴면</td></c:when>
							<c:when test="${member.member_status eq 3}"><td class="member_status_withdraw">탈퇴</td></c:when>
						</c:choose>
					<td>
						<%-- 상세정보 버튼 클릭 시 상세정보 조회를 위한 "MemberInfo" 서블릿 요청 --%>
						<%-- 클릭 시 파라미터로 해당 회원의 아이디를 함께 전달(기존처럼 세션 아이디를 넘기는게 아닌 파라미터로 회원의 아이디를 넘김) --%>
						<input type="button" value="상세정보" onclick="location.href='MemberInfo?id=${member.id}'">
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














