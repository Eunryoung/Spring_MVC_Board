<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		<!-- JSP 파일 삽입 대상은 현재 파일을 기준으로 상대주소 지정 -->
		<!-- webapp 디렉토리를 가리키려면 최상위(루트) 경로 활용 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<h1>회원탈퇴</h1>
		<form action="MemberWithdrawPro" method="post">
			<table>
				<tr>
					<td>
						탈퇴 확인을 위해 비밀번호를 입력하세요.<br>	
					</td>
				</tr>
				<tr>
					<td>
						<input type="password" placeholder="패스워드" name="passwd" required><br>
					</td>
				</tr>
				<tr>
					<td class="td_center">
						<input type="submit" value="회원탈퇴">
					</td>
				</tr>
			</table>
		</form>
	</article>
	<footer>
	
	</footer>
</body>
</html>







