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
function authAccount() {
	// 새 창을 사용하여 사용자 인증 페이지 요청
	let requestUri = "https://testapi.openbanking.or.kr/oauth/2.0/authorize?"
						+ "response_type=code"
						+ "&client_id=4066d795-aa6e-4720-9383-931d1f60d1a9"
						+ "&redirect_uri=http://localhost:8081/mvc_board/callback"
						+ "&scope=login inquiry transfer"
// 						+ "&state=12345678901234567890123456789012"
						+ "&state=${sessionScope.state}" // 세션에 저장된 state 값을 사용
						+ "&auth_type=0";
	window.open(requestUri, "authWindow", "width=600, height=800");
}
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
		<input type="button" value="계좌인증" onclick="authAccount()">
		<!-- 엑세스 토큰이 세션에 존재할 경우 사용자 정보 조회 버튼 표시(FintechUserInfo 서블릿 요청) -->
		<!-- 단, 계좌인증 버튼은 임시로 항상 표시되도록 아무것도 처리하지 않음 -->
		<c:if test="${not empty sessionScope.access_token }">
			<input type="button" value="핀테크 사용자 정보 조회" onclick="location.href='FintechUserInfo'">
		</c:if>			
		<%-- 관리자에 대한 oob 권한을 갖는 엑세스토큰 발급 요청 --%>
		<c:if test="${not empty sessionScope.sId and sessionScope.sId eq 'admin'}">
			<input type="button" value="관리자 엑세스토큰(oob) 발급 요청" onclick="location.href = 'FintechAdminAccessToken'">
		</c:if>
		
	</article>
	<footer>
		<!-- 회사소개 표시 영역(bottom.jsp 페이지 삽입) -->
		<jsp:include page="../inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>














