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
	#modifyForm {
		width: 500px;
		height: 550px;
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
	
	.img_btnDelete {
		width: 10px;
		height: 10px;
	}
	
</style>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	function deleteFile(board_num, board_file, index) {
// 		alert(board_num + ", " + board_file + ", " + index); // 16, 2023/12/26/afd0bc11_license.txt, 1
		if(confirm("삭제하시겠습니까?")) {
			// 파일 삭제 작업을 AJAX로 처리하기 - POST
			// BoardDeleteFile 서블릿 요청(파라미터: 글번호, 파일명)
			$.ajax({
				url: "BoardDeleteFile",
				type: "post",
				data: {
// 					"index": index, // BoardVO에 없으므로 받아와지지 않아서 컨트롤러에서 파라미터 추가해야함
					// => but 지금 DB 구조에서는 필요X
					//    인덱스 없이 디비와 연결해줄 파라미터명 지정 아래에서 가능(인덱스는 제이쿼리 처리를 위해서만 씀)
					"board_num": board_num,
// 					board_file: board_file // board_file1: board_file로 파라미터 넘기면 컨트롤러에서 BoardVO의 boardfile1과 연결시켜준다!
					// 전달받은 파일명을 컬럼 구별없이 검색하기 위해 board_file1으로 지정(board_file2, board_file3도 무관)
					"board_file1": board_file // 지울 파일이 db의 board_file1에 들어감
				},
				success: function(result) {
					console.log("파일 삭제 요청 결과 : " + result); // true
					console.log("파일 삭제 요청 결과 데이터타입: " + typeof(result)); // string
					
					// 삭제 성공/실패 여부 판별(result 값 문자열 : "true"/"false" 판별)
					if(result == "true") { // 삭제 성공 시
						// 기존 파일 다운로드 링크 요소를 제거하고 
						// 파일 업로드를 위한 파일 선택 요소 표시 => html() 활용: empty() + append() 합침
						// => ID 선택자 "fileItemAreaX"인 요소 지정(X는 index 값 활용)
						// => 표시할 태그 요소 : <input type="file" name="file1" />
						//	  => name 속성값도 index 값을 활용하여 각 파일마다 다른 name 값 사용
						// c.f. 클래스 선택자가 "file"인 요소의 eq(index-1) 하거나 each써서 파라미터로 index 넘겨주는 방법도 있다!
						$("#fileItemArea" + index).html('<input type="file" name="file' + index + '" />'); 
					} else if(result == "false") {
						alert("파일 삭제 실패");
					}
					
				}
				
			});
		}
		
	}
</script>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 글 수정 -->
	<article id="modifyForm">
		<h1>게시판 글 수정</h1>
		<%-- 수정 시에도 업로드 파일 처리를 위해 enctype 속성 추가 --%>
		<form action="BoardModifyPro" name="modifyForm" method="post" enctype="multipart/form-data">
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
				<tr>
					<td class="td_left"><label for="board_file">첨부파일</label></td>
					<td class="td_right">
						<div class="file" id="fileItemArea1">
							<c:choose>
								<c:when test="${not empty board.board_file1}">
									<c:set var="original_file_name1" value="${fn:substringAfter(board.board_file1, '_')}"/>
									
									<%-- 다운로드 버튼을 활용하여 해당 파일 다운로드 --%>
									<%-- 버튼에 하이퍼링크 설정하여 download 속성 설정 시 다운로드 가능 --%>
									<%-- 이 때, download 속성값 지정 시 다운로드 되는 파일명 변경 가능 --%>
									<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file1}" download="${original_file_name1}">${original_file_name1}</a>
									<%-- 파일명 뒤의 삭제 아이콘 클릭 시 deleteFile() 함수 호출 --%>
									<%-- a링크 안에 javascript: 서술 --%>
									<%-- 파라미터 : 글번호, 실제 업로드 된 파일명 --%>
<%-- 									<a href="javascript:deleteFile(${board.board_num}, '${board.board_file1 }')"> 파일명은 ''로 감싼다! --%>
									<%-- 삭제 작업 후 해당 태그 요소 제어를 위해 구분자로 요소의 번호(임의 전달) --%>
									<%-- 파라미터 : 글번호, 실제 업로드 된 파일명, 인덱스로 사용하기 위한 번호 --%>
									<a href="javascript:deleteFile(${board.board_num}, '${board.board_file1 }', 1)"> <%-- 파일명은 ''로 감싼다! --%>
	<%-- 								<a href="javascript:void(0)" onclick="deleteFile()"> void(0) 으로 걸어서 deleteFile()로 이동하지 않도록 하고 온클릭 자바스크립트 실행 --%>
									<%-- void(0)를 사용하는 이유는 onclick 이외에도 많은 것들을 할 수 있음!!! --%>
										<img src="${pageContext.request.contextPath }/resources/images/delete-icon.png" class="img_btnDelete">
									</a>
								</c:when>
								<c:otherwise>
									<input type="file" name="file1" />
								</c:otherwise>
							</c:choose>
						</div>
						<div class="file" id="fileItemArea2">
							<c:choose>
								<c:when test="${not empty board.board_file2}">
									<c:set var="original_file_name2" value="${fn:substringAfter(board.board_file2, '_')}"/>
									<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file2}" download="${original_file_name2}">${original_file_name2}</a>
									<a href="javascript:deleteFile(${board.board_num}, '${board.board_file2 }', 2)">
										<img src="${pageContext.request.contextPath }/resources/images/delete-icon.png" class="img_btnDelete">
									</a>
								</c:when>
								<c:otherwise>
									<input type="file" name="file2" />
								</c:otherwise>
							</c:choose>
						</div>
						<div class="file" id="fileItemArea3">
							<c:choose>
								<c:when test="${not empty board.board_file3}">
									<c:set var="original_file_name3" value="${fn:substringAfter(board.board_file3, '_')}"/>
									<a href="${pageContext.request.contextPath }/resources/upload/${board.board_file3}" download="${original_file_name3}">${original_file_name3}</a>
									<a href="javascript:deleteFile(${board.board_num}, '${board.board_file3 }', 3)">
										<img src="${pageContext.request.contextPath }/resources/images/delete-icon.png" class="img_btnDelete">
									</a>
								</c:when>
								<c:otherwise>
									<input type="file" name="file3" />
								</c:otherwise>
							</c:choose>
						</div>
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








