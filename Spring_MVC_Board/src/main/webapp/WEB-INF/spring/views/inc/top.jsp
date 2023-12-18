<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
	 // 확인창(confirm 다이얼로그)을 통해 로그아웃 여부를 확인할 confirmLogout() 함수 정의
	 function confirmLogout() {
		 let isLogout = confirm("로그아웃하시겠습니까?"); // true/false 리턴
		 
		 // isLogout 변수값이 true 일 경우 로그아웃("MemberLogout") 서블릿 요청
		 if(isLogout) {
			 location.href = "MemberLogout";
		 }
	 }
</script>
<div id="member_area">
	<a href="./">HOME</a>
	<%-- 로그인 여부(세션 아이디 존재 여부) 판별하여 각각 다른 링크 표시 --%>
	<%-- EL 의 sessionScope 내장객체 에 접근하여 "sId" 속성값 존재 여부 판별 --%>
	<c:choose>
		<c:when test="${empty sessionScope.sId }"> <%-- 미 로그인 시 --%>
			| <a href="MemberLoginForm">로그인</a>
			| <a href="MemberJoinForm">회원가입</a>
		</c:when>
		<c:otherwise>
			<%-- 아이디 클릭 시 회원정보 상세조회를 위한 MemberInfo 서블릿 요청 --%>
			| <a href="MemberInfo">${sessionScope.sId }</a>
			<%-- 로그아웃 클릭 시 자바스크립트 confirmLogout() 함수 실행 --%>
			| <a href="javascript:confirmLogout()">로그아웃</a>
		</c:otherwise>
	</c:choose>
</div>
<hr>






