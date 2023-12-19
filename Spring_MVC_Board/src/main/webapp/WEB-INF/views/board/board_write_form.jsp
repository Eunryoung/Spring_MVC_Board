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
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 등록 -->
	<article id="writeForm">
		<h1>게시판 글 등록</h1>
		<%-- 파일 업로드 처리를 위해 form 태그 enctype 속성값을 "multipart/form-data" 로 설정 --%>
		<%-- 모든 파라미터는 request 객체를 통한 직접 접근 불가능해진다! --%>
		<%-- 미설정 시 기본값 : application/x-www-form-urlencoded --%>
		<form action="BoardWritePro" name="writeForm" method="post" enctype="multipart/form-data">
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
				<tr>
					<td class="write_td_left"><label for="file1">파일첨부</label></td>
					<td class="write_td_right">
						<%-- 파일 첨부 형식은 input 태그 type="file" 속성 활용 --%>
						<%-- 한 번에 하나의 파일 선택 가능 --%>
						<input type="file" name="file1" />
						<input type="file" name="file2" />
						<input type="file" name="file3" />
						<br> --------------- <br>
						<%-- 한 번에 복수개의 파일 선택 시 multiple 속성 추가 --%>
						<input type="file" name="file" multiple />
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








