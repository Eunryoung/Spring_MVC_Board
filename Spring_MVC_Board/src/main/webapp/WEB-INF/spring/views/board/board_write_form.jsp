<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#writeForm {
		width: 500px;
		height: 450px;
		margin: auto;
	}
	
	#writeForm > table {
		margin: auto;
		width: 450px;
	}
	
	.write_td_left {
		width: 150px;
		background: orange;
		text-align: center;
	}
	
	.write_td_right {
		width: 300px;
		background: skyblue;
	}
</style>
</head>
<body>
	<%-- 로그인 하지 않은 사용자 접근 시 "회원만 글쓰기 가능합니다." 출력 후 로그인 페이지로 이동 --%>
	<c:if test="${empty sessionScope.sId }">
		<script type="text/javascript">
			alert("회원만 글쓰기가 가능합니다.\n로그인 페이지로 이동합니다.");
			location.href = "MemberLoginForm.me";
		</script>
	</c:if>
	
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 등록 -->
	<article id="writeForm">
		<h1>게시판 글 등록</h1>
		<form action="BoardWritePro.bo" name="writeForm" method="post">
			<table>
				<tr>
					<td class="write_td_left"><label for="board_name">글쓴이</label></td>
					<td class="write_td_right">
						<%-- 작성자는 세션 아이디값 그대로 사용(읽기 전용) --%>
						<input type="text" name="board_name" value="${sessionScope.sId }" readonly />
					</td>
				</tr>
				<tr>
					<td class="write_td_left"><label for="board_subject">제목</label></td>
					<td class="write_td_right"><input type="text" id="board_subject" name="board_subject" required="required" /></td>
				</tr>
				<tr>
					<td class="write_td_left"><label for="board_content">내용</label></td>
					<td class="write_td_right">
						<textarea id="board_content" name="board_content" rows="15" cols="40" required="required"></textarea>
					</td>
				</tr>
			</table>
			<section id="commandCell">
				<input type="submit" value="등록">&nbsp;&nbsp;
				<input type="reset" value="다시쓰기">&nbsp;&nbsp;
				<input type="button" value="취소" onclick="history.back()">
			</section>
		</form>
	</article>
</body>
</html>








