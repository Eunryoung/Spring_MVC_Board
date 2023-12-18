<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#modifyForm {
		width: 500px;
		height: 450px;
		margin: auto;
	}
	
	h1 {
		text-align: center;
	}
	
	table {
		margin: auto;
		width: 450px;
	}
	
	.td_left {
		width: 150px;
		background: orange;
		text-align: center;
	}
	
	.td_right {
		width: 300px;
		background: skyblue;
	}
	
	#commandCell {
		text-align: center;
	}
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 글 수정 -->
	<article id="modifyForm">
		<h1>게시판 글 수정</h1>
		<form action="BoardModifyPro.bo" name="modifyForm" method="post">
			<%-- 직접 입력받지 않은 글번호, 페이지번호를 폼 파라미터로 함께 전달하기 위해 --%>
			<%-- input type="hidden" 속성을 활용하여 폼 데이터로 추가 가능 --%>
			<%-- name 속성에 파라미터 이름, value 속성에 파라미터 값 지정 --%>
			<input type="hidden" name="board_num" value="${board.board_num}">
			<input type="hidden" name="pageNum" value="${param.pageNum}">
			<table>
				<tr>
					<td class="td_left"><label for="board_name">글쓴이</label></td>
					<td class="td_right">
						<%-- 작성자(글쓴이)는 편집 불가능하므로 그냥 출력만 수행해도 무관 --%>
						${board.board_name }
					</td>
				</tr>
				<%-- 제목과 내용은 수정이 가능하도록 입력폼으로 표시 --%>
				<tr>
					<td class="td_left"><label for="board_subject">제목</label></td>
					<td class="td_right">
						<input type="text" name="board_subject" value="${board.board_subject}" required>
					</td>
				</tr>
				<tr>
					<td class="td_left"><label for="board_content">내용</label></td>
					<td class="td_right">
						<textarea rows="15" cols="40" name="board_content" required>${board.board_content}</textarea>
					</td>
				</tr>
			</table>
			<section id="commandCell">
				<input type="submit" value="수정">&nbsp;&nbsp;
				<input type="reset" value="다시쓰기">&nbsp;&nbsp;
				<input type="button" value="취소" onclick="history.back()">
			</section>
		</form>
	</article>
</body>
</html>








