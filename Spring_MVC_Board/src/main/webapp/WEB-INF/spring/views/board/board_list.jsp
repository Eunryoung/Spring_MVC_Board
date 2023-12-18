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
		<input type="button" value="글쓰기" onclick="location.href='BoardWriteForm.bo'" />
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
			<%-- JSTL 과 EL 활용하여 글목록 표시 작업 반복(boardList 객체 활용) --%>
			<c:forEach var="board" items="${boardList}">
				<tr>
					<td>${board.board_num}</td>
					<td id="subject">
						<%-- ========== 답글 관련 처리 ========== --%>
						<%-- board_re_lev 값이 0 보다 크면 답글이므로 들여쓰기 후 이미지(re.gif) 추가 --%>
						<c:if test="${board.board_re_lev > 0}">
							<%-- 반복문을 통해 board_re_lev 값만큼 공백(&nbsp;) 2개씩 추가 --%>
							<%-- ex) lev = 1 일 때 2칸, lev = 2 일 때 4칸 --%>
							<c:forEach begin="1" end="${board.board_re_lev}">
								&nbsp;&nbsp;							
							</c:forEach>
							<img src="${pageContext.request.contextPath }/resources/images/re.gif">
						</c:if>
						<%-- 제목 클릭 시 하이퍼링크 설정(BoardDetail.bo) --%>
						<%-- 파라미터 : 글번호(board_num), 페이지번호(pageNum) --%>
						<a href="BoardDetail.bo?board_num=${board.board_num}&pageNum=${pageNum}">${board.board_subject}</a>
					</td>
					<td>${board.board_name}</td>
					<td>
						<%--
						JSTL 의 fmt(format) 라이브러리를 활용하여 날짜 및 시각 형식(포맷) 변경
						1) <fmt:formatDate> : Date 객체 날짜 형식 변경
						   => <fmt:formatDate value="${날짜 및 시각 객체}" pattern="표현패턴">
						   => 자바의 SimpleDateFormat 클래스와 동일한 역할 수행
						2) <fmt:parseDate> : String 객체 날짜 형식 변경
						--%>
						<fmt:formatDate value="${board.board_date}" pattern="yy-MM-dd HH:mm"/>
					</td>
					<td>${board.board_readcount}</td>
				</tr>
			</c:forEach>
		</table>
	</section>
	<section id="pageList">
		<%-- [이전] 버튼 클릭 시 BoardList.bo 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
		<%-- 단, 현재 페이지 번호(pageNum) 가 1보다 클 경우에만 동작(아니면 비활성화 처리) --%>
<%-- 		<c:choose> --%>
<%-- 			<c:when test="${pageNum > 1 }"> --%>
<!-- 				<input type="button" value="이전"  -->
<%-- 					onclick="location.href = 'BoardList.bo?pageNum=${pageNum - 1}'"> --%>
<%-- 			</c:when> --%>
<%-- 			<c:otherwise> --%>
<!-- 				<input type="button" value="이전"  -->
<%-- 					onclick="location.href = 'BoardList.bo?pageNum=${pageNum - 1}'" disabled> --%>
<%-- 			</c:otherwise> --%>
<%-- 		</c:choose> --%>
		<input type="button" value="이전"
				onclick="location.href = 'BoardList.bo?pageNum=${pageNum - 1}'"
				<c:if test="${pageNum <= 1 }">disabled</c:if>
		>	
	
		<%-- 현재 페이지 번호가 저장된 pageInfo 객체를 통해 페이지 번호 출력 --%>
		<%-- 시작페이지(startPage) 부터 끝페이지(endPage) 까지 표시 --%>
		<c:forEach var="i" begin="${pageInfo.startPage }" end="${pageInfo.endPage }">
			<%-- 각 페이지마다 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
			<%-- 단, 현재 페이지는 하이퍼링크 제거하고 굵게 표시 --%>
			<c:choose>
				<%-- 현재 페이지번호와 표시될 페이지번호가 같을 경우 판별 --%>
				<c:when test="${pageNum eq i }">
					<b>${i }</b> <%-- 현재 페이지 번호 --%>
				</c:when>
				<c:otherwise>
					<a href="BoardList.bo?pageNum=${i }">${i }</a> <%-- 다른 페이지 번호 --%>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		
		<%-- [다음] 버튼 클릭 시 BoardList.bo 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
		<%-- 단, 현재 페이지 번호(pageNum) 가 최대 페이지번호 보다 작을 경우에만 동작(아니면 비활성화 처리) --%>
		<input type="button" value="다음" 
			onclick="location.href = 'BoardList.bo?pageNum=${pageNum + 1}'"
			<c:if test="${pageNum >= pageInfo.maxPage }">disabled</c:if>
		>	
	</section>
</body>
</html>













