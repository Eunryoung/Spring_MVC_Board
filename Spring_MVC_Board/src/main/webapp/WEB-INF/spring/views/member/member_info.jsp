<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL 에서 제공하는 각종 함수 라이브러리 : functions --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
				<td>${member.post_code} ${member.address1} ${member.address2}</td>
			</tr>
			<tr>
				<th>E-Mail</th>
				<td>${member.email }</td>
			</tr>
			<tr>
				<th>직업</th>
				<td>${member.job}</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>${member.gender}</td>
			</tr>
			<tr>
				<th>취미</th>
<%-- 				<td>${member.hobby }</td> --%>
				<%-- JSTL functions 라이브러리의 replace() 함수를 활용하여 , 를 공백으로 치환 --%>
				<%-- ${fn:replace(원본문자열, "대상문자열", "치환할문자열")} --%>
				<td>${fn:replace(member.hobby, ",", " ")}</td>
			</tr>
			<tr>
				<th>가입동기</th>
				<td>${member.motivation}</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" value="정보수정" onclick="location.href = 'MemberModifyForm'">
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