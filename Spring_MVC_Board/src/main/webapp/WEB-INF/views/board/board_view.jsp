<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#articleForm {
		width: 500px;
		height: 550px;
		border: 1px solid red;
		margin: auto;
	}
	
	h2 {
		text-align: center;
	}
	
	table {
		border: 1px solid black;
		border-collapse: collapse; 
	 	width: 500px;
	}
	
	th {
		text-align: center;
	}
	
	td {
		width: 150px;
		text-align: center;
	}
	
	#basicInfoArea {
		height: 130px;
		text-align: center;
	}
	
	#articleContentArea {
		background: orange;
		margin-top: 20px;
		height: 350px;
		text-align: center;
		overflow: auto;
		white-space: pre-line;
	}
	
	#commandList {
		margin: auto;
		width: 500px;
		text-align: center;
	}
</style>
<script type="text/javascript">
	// 삭제 버튼 클릭 시 확인창을 통해 "삭제하시겠습니까?" 출력 후
	// 확인 버튼 클릭 시 "BoardDelete" 서블릿 요청(파라미터 : 글번호, 페이지번호)
	function confirmDelete() {
		if(confirm("삭제하시겠습니까?")) {
			location.href = "BoardDelete?board_num=${board.board_num}&pageNum=${param.pageNum}"; // 파라미터로 board_num, pageNum 넘김(디스패치 타입)
		}
	}
</script>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 상세내용 보기 -->
	<article id="articleForm">
		<h2>글 상세내용 보기</h2>
		<section id="basicInfoArea">
			<table border="1">
			<tr><th width="70">제 목</th><td colspan="3" >${board.board_subject}</td></tr>
			<tr>
				<th width="70">작성자</th><td>${board.board_name}</td>
				<th width="70">작성일자</th>
				<td><fmt:formatDate value="${board.board_date}" pattern="yyyy-MM-dd HH:mm"/></td>
			</tr>
			<tr>
				<th width="70">조회수</th><td>${board.board_readcount}</td>
				<th width="70">작성자IP</th><td>${board.writer_ip}</td>
			</tr>
			<tr>
				<th width="70">파일</th>
				<td colspan="3">
					<%-- 파일명에서 업로드 한 원본 파일명만 추출하기 --%>
					<%-- 1) split() 함수 활용하여 "_" 구분자로 분리하여 1번 인덱스 배열 사용 --%>
<%-- 						${fn:split(board.board_file1, "_")[1]} --%>
<!-- 						<br> -->
					<%-- 2) substringAfter() 함수 활용하여 기준 문자열의 다음 모든 문자열 추출 --%>
<%-- 						${fn:substringAfter(board.board_file2, "_")}<br> --%>
					<%-- 3) substring() 함수 활용하여 시작 인덱스부터 지정한 인덱스까지 문자열 추출 --%>
					<%-- 단, 전체 파일명의 길이를 지정한 인덱스로 활용하기 위해 length() 함수 추가 사용 => 변수에 저장 필요 --%>
<%-- 						<c:set var="file3_length" value="${fn:length(board.board_file3)}" /> --%>
<%-- 						${fn:substring(board.board_file3, 20, file3_length)}<br> --%>
					<%-- =========================================================== --%>
					
					
					<div class = "file">
						<c:if test="${not empty board.board_file1}"> <%-- 파일이름이 비어있지않다면 아래 내용 표시 --%>
							<c:set var="original_file_name1" value="${fn:substringAfter(board.board_file1, '_')}"/>
							${original_file_name1}
							<%-- 다운로드 버튼을 활용하여 해당 파일 다운로드 --%>
							<%-- 버튼에 하이퍼링크 설정하여 download 속성 설정 시 다운로드 가능 --%>
							<%-- 이 때, download 속성값 지정 시 다운로드 되는 파일명 변경 가능 --%>
							<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file1}" download="${original_file_name1}"><input type="button" value="다운로드"></a>
						</c:if>
					</div>
					
					<div class = "file">
						<c:if test="${not empty board.board_file2}">
							<c:set var="original_file_name2" value="${fn:substringAfter(board.board_file2, '_')}"/>
							${original_file_name2}
							<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file2}" download="${original_file_name2}"><input type="button" value="다운로드"></a>
						</c:if>
					</div>
					
					<div class = "file">
						<c:if test="${not empty board.board_file3}">
							<c:set var="original_file_name3" value="${fn:substringAfter(board.board_file3, '_')}"/>
							${original_file_name3}
							<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file3}" download="${original_file_name3}"><input type="button" value="다운로드"></a>
						</c:if>
					</div>
				</td>
			</tr>
			</table>
		</section>
		<section id="articleContentArea">
			${board.board_content}
		</section>
	</article>
	<section id="commandCell">
		<%-- 답변 버튼은 세션 아이디가 있을 경우에만 표시(생략) --%>
<%-- 		<c:if test="${not empty sessionScope.sId }"> --%>
<%-- 			<input type="button" value="답변" onclick="location.href='BoardReplyForm?board_num=${board.board_num}&pageNum=${param.pageNum}'"> --%>
<%-- 		</c:if> --%>
		
		<%-- 답변과 목록 버튼은 항상 표시 --%>
		<%-- 수정, 삭제 버튼은 세션 아이디가 있고, 작성자 아이디와 세션 아이디가 같을 경우에만 표시 --%>
		<%-- 단, 세션 아이디가 관리자일 경우에도 수정, 삭제 버튼 표시 --%>
		<%-- 답변, 수정, 삭제는 BoardXXXForm.bo 서블릿 요청(파라미터 : 글번호, 페이지번호) --%>
		<%-- 답변 : BoardReplyForm, 수정 : BoardModifyForm, 삭제 : BoardDeleteForm --%>
		<input type="button" value="답변" onclick="location.href='BoardReplyForm?board_num=${board.board_num}&pageNum=${param.pageNum}'">
		<c:if test="${not empty sessionScope.sId and ((board.board_name eq sessionScope.sId) or (sessionScope.sId eq 'admin'))}">
			<input type="button" value="수정" onclick="location.href='BoardModifyForm?board_num=${board.board_num}&pageNum=${param.pageNum}'">
	<%-- 		<input type="button" value="삭제" onclick="location.href='BoardDeleteForm?board_num=${board.board_num}&pageNum=${param.pageNum}'"> --%>
			<%-- 삭제 시 패스워드 확인이 불필요하여 뷰페이지가 필요없으므로 --%>
			<%-- 자바스크립트를 통해 삭제 확인 후 바로 비즈니스 로직 요청 --%>
	<%-- 		<input type="button" value="삭제" onclick="confirmDelete(${board.board_num}, ${param.pageNum})"> --%>
			<input type="button" value="삭제" onclick="confirmDelete()">
		</c:if>
		
		<%-- 목록은 BoardList.bo 서블릿 요청(파라미터 : 페이지번호) --%>
		<input type="button" value="목록" onclick="location.href='BoardList?pageNum=${param.pageNum}'">
	</section>
</body>
</html>
















