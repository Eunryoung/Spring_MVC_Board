<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL 에서 제공하는 각종 함수 라이브러리 : functions --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
</head>
<body>
	<header>
		<!-- inc/top.jsp 페이지 삽입 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<h1>회원 상세정보</h1>
		<table border="1">
			<tr>
				<th>이름</th>
				<%-- request 객체에 저장된 "member" 속성에 접근하여 정보 출력 --%>
				<%-- request 객체명 생략, MemberBean 객체의 멤버변수명으로 접근 --%>
				<%-- => 실제로는 MemberBean 객체의 Getter 메서드가 호출됨 --%>
				<td>${member.name }</td>
			</tr>
			<tr>
				<th>아이디</th>
				<td>${member.id }</td>
			</tr>
			<tr>
				<th>주민번호</th>
				<td>${member.jumin }</td>
			</tr>
			<tr>
				<th>주소</th>
				 <%-- DB의 컬럼명과 일치하도록 ${member.address } 에서 아래와 같이 수정해야 오류 발생X --%>
				<td>${member.post_code } ${member.address1 } ${member.address2 }</td>
			</tr>
			<tr>
				<th>E-Mail</th>
				<td>${member.email }</td>
			</tr>
			<tr>
				<th>직업</th>
				<td>${member.job }</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>${member.gender }</td>
			</tr>
			<tr>
				<th>취미</th>
<%-- 				<td>${member.hobby }</td> --%>
				<%-- JSTL funcions 라이브러리의 replace() 함수를 활용하여 ,를 공백으로 치환 --%>
				<%-- ${fn:replace(원본문자열, "대상문자열", "치환할문자열")} --%>
				<td>${fn:replace(member.hobby, ",", " ") }</td>
			</tr>
			<tr>
				<th>가입동기</th>
				<td>${member.motivation }</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				
					<c:choose>
						<%-- 만약, 현재 세션 아이디가 관리자이면서, 조회할 아이디가 관리자가 아닐 경우 --%>
						<%-- 회원정보수정폼 요청 시 id 파라미터로 조회할 회원의 아이디 전달 --%>
						<c:when test="${sessionScope.sId eq 'admin' and param.id ne 'admin' }"> <%-- param.id 대신 member.id 써도 됨 --%>
							<input type="button" value="정보수정" onclick="location.href = 'MemberModifyForm?id=${member.id}'"> <%-- 관리자일 경우 url에 파라미터로 id 전달 --%>
						</c:when>

						<%--  --%>
						<c:otherwise>
							<input type="button" value="정보수정" onclick="location.href = 'MemberModifyForm'">
						</c:otherwise>
					</c:choose>
					
					<input type="button" value="회원탈퇴" onclick="location.href = 'MemberWithdrawForm'">
					<input type="button" value="돌아가기">
				</td>
			</tr>
		</table>
	</article>
	<footer>
	
	</footer>
</body>
</html>