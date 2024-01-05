<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 출력 형식 변경을 위해 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#listForm {
		width: 1024px;
		max-height: 610px;
		margin: auto;
	}
	
	h2 {
		text-align: center;
	}
	
	table {
		margin: auto;
		width: 1024px;
	}
	
	#tr_top {
		background: orange;
		text-align: center;
	}
	
	table td {
		text-align: center;
	}
	
	#pageList {
		margin: auto;
		width: 1024px;
		text-align: center;
	}
	
	#emptyArea {
		margin: auto;
		width: 1024px;
		text-align: center;
	}
	
	#buttonArea {
		margin: auto;
		width: 1024px;
		text-align: right;
	}
	
	/* 하이퍼링크 밑줄 제거 */
	a {
		text-decoration: none;
	}
	
	/* 제목 열 좌측 정렬 및 여백 설정 */
	#subject {
		text-align: left;
		padding-left: 20px;
	}
</style>
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	// 무한 스크롤 기능에 활용될 페이지번호 변수 선언(초기값 1)
	// => 함수 안쪽과 document. ready 이벤트 안에서 같이 사용되어야하므로 밖에서 선언
	let pageNum = "1";
	let maxPage = "";

	$(function() {
		// board_list.jsp 페이지 로딩 시 게시물 목록 조회 수행을 위해 load_list() 함수 호출
		load_list();
		
		// 무한스크롤 기능을 통해 다음 글 목록 자동으로 로딩
		$(window).scroll(function() { // 윈도우 스크롤 이벤트 핸들링
// 			console.log("window scroll");
		
			// 1. window 객체와 document 객체를 활용하여 스크롤 관련 값 가져오기
			let scrollTop = $(window).scrollTop(); // 스크롤바 현재 위치
			let windowHeight = $(window).height(); // 브라우저 창 높이
			let documentHeight = $(document).height(); // 문서 높이
// 			console.log("scrollTop : " + scrollTop + " windowHeight : " + windowHeight + " documentHeight : " + documentHeight);
			// scrollTop : 0, windowHeight : 607, documentHeight : 649
			// scrollTop : 41.33333206176758, windowHeight : 607, documentHeight : 649
			
			// 2. 스크롤바 위치값 + 창 높이 + x 값이 문서 전체 높이 이상일 경우
			//    다음 페이지 게시물 목록 로딩하여 화면에 추가
			//    이 때, x 값의 역할은 스크롤바가 바닥으로부터 얼마만큼 떨어져 있을지 결정
			//    (x 값이 커질 수록 스크롤바가 더 높은 곳에 위치해도 다음 페이지 로딩 동작 수행)
			if(scrollTop + windowHeight + 1 >= documentHeight) { 
				// => 1 더했기 때문에 바닥에 닿아야 다시 스크롤 생성(숫자 커질수록 스크롤 많이 남았어도 목록 더 뜬다)
				pageNum++; // 다음 목록 조회를 위해 현재 페이지번호 1 증가
				
				// 만약, 증가된 페이지번호가 끝 페이지 번호보다 작거나 같을 경우에만 다음 페이지 로딩
				// => 단, 끝 페이지 번호가 널스트링일 경우에는 로딩 수행 X
				if(maxPage != "" && pageNum <= maxPage) {
					load_list(); // 다음 페이지 로딩을 위해 load_list() 함수 호출
				}
				
			}
		});
		
	});
	
	// 게시물 목록 조회를 AJAX + JSON 으로 처리할 load_list() 함수 정의
	function load_list() {
		let searchType = $("#searchType").val();
		let searchKeyword = $("#searchKeyword").val();
		
		// "BoardListJson" 서블릿 요청 - AJAX
		// => 요청 메서드 : GET
		//    파라미터 : 검색타입, 검색어, 페이지번호
		//    응답데이터 타입: "json"(응답 데이터를 JSON 객체로 인식)
		$.ajax({
			type: "get",
			url:"BoardListJson",
			data: {
				"searchType": searchType,
				"searchKeyword": searchKeyword,
				"pageNum": pageNum
			},
			dataType: "json",
			success: function(data) {
// 				let result = "<tr><td colspan='5'>" + JSON.stringify(data) + "</td></tr>";
// 				$("#listForm > table").append(result);

				// JSON 객체 형식으로 전달받은 응답데이터 처리
				// => 콜백함수 파라미터 data 에는 Map 객체가 전달되었으므로 JSON 객체({})로 관리됨
				//    따라서, data 객체 내의 List 객체를 JSON 배열([]) 형식으로 꺼내서 처리 필요
				for(let board of data.boardList) { // 목록 반복하면서 객체 1개를 board 에 저장
// 					let result = "<tr><td colspan='5'>" + JSON.stringify(board) + "</td></tr>";

					// board 객체의 board_re_lev 값이 0보다 클 경우 추가할 항목 생성
					// 제목열에 해당 값만큼 공백(&nbsp;) 추가 후 답글 아이콘 이미지(re.gif) 추가
					let re = "";
					if(board.board_re_lev > 0) {
						for(let i = 0; i < board.board_re_lev; i++) {
							re += "&nbsp;&nbsp;";
						}
						
						re += '<img src="${pageContext.request.contextPath }/resources/images/re.gif">';
					}
					
					// 테이블에 출력할 JSON 데이터에 대한 출력문 생성(1개 게시물씩 반복됨)
					// => 출력할 데이터는 board 객체를 통해 접근(board.xxx)
					let result = "<tr>"
									+ "<td>" + board.board_num + "</td>"
									+ "<td id='subject'>" 
										+ re
										+ '<a href="BoardDetail?board_num=' + board.board_num + '">' 
											+ board.board_subject 
										+ '</a>'
									+ "</td>"
									+ "<td>" + board.board_name + "</td>"
									+ "<td>" + board.board_date + "</td>"
									+ "<td>" + board.board_readcount + "</td>"
								+ "</tr>";
					
					$("#listForm > table").append(result);
					
					// 끝페이지 번호(maxPage) 값을 변수에 저장
					maxPage = data.maxPage;

				}


			},
			error: function() {
				alert("요청 실패!");		
			}
			
		});
	}
</script>
</head>
<body>
	<%-- pageNum 파라미터 가져와서 저장(없을 경우 기본값 1로 설정) --%>
	<c:set var="pageNum" value="1" />
	<c:if test="${not empty param.pageNum }">
		<c:set var="pageNum" value="${param.pageNum }" />
	</c:if>

	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>

	<!-- 게시판 리스트 -->
	<h2>게시판 글 목록</h2>
	<section id="buttonArea">
		<%-- 검색 기능을 위한 폼 생성 --%>
		<form action="BoardList">
			<%-- 검색타입 목록(셀렉트박스), 검색어(텍스트박스) 추가 --%>
			<select name="searchType">
				<%-- 파라미터로 검색타입 목록이 넘어온게 남아있음(새로고침하면 항목에 맞게 셀렉트 되고 텍스트박스에도 검색 키워드 내용 남아있도록) --%>
				<option value="subject"<c:if test="${param.searchType eq 'subject' }">selected</c:if>>제목</option>
				<option value="content"<c:if test="${param.searchType eq 'content' }">selected</c:if>>내용</option>
				<option value="subject_content" <c:if test="${param.searchType eq 'subject_content' }">selected</c:if>>제목&내용</option>
				<option value="name" <c:if test="${param.searchType eq 'name' }">selected</c:if>>작성자</option>
			</select>
			<input type="text" name="searchKeyword" value="${param.searchKeyword }">
			<input type="submit" value="검색">
			<input type="button" value="글쓰기" onclick="location.href='BoardWriteForm'" />
		</form>
	</section>
	<section id="listForm">
		<table>
			<tr id="tr_top">
				<td width="100px">번호</td>
				<td>제목</td>
				<td width="150px">작성자</td>
				<td width="150px">날짜</td>
				<td width="100px">조회수</td>
			</tr>
			<%-- AJAX 를 활용한 요청으로 전달받은 글목록 출력 위치 --%>
			
		</table>
	</section>
</body>
</html>













