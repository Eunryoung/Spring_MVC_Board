<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	// 컨트롤러에서 전달받은 msg 속성값을 EL을 통해 접근하여 alert() 함수로 출력
	alert("${msg}");
	// 전달받은 targetURL 속성값 location.href 로 이동 처리
	location.href="${targetURL}";
	</script>