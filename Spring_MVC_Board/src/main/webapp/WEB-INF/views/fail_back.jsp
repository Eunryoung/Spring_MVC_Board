<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	// 컨트롤러에서 전달받은 오류메세지를 EL을 통해 접근하여 alert() 함수로 출력
	alert("${msg}");
	
	// Model 객체로 전달받은 "isClose" 값이 true 일 경우 현재 창 종료, 아니면 이전페이지로 돌아가기
	// => 단, Model 객체에 저장된 실제 데이터타입과 상관없이 자바스크립트에서 문자열로 처리
	if("${isClose}" == "true") { // 만약, "true" 일 때만 문자열 전달 시 == "true" 생략해도 됨
// 	if("${isClose}") { 
		// => 문자열이 있기만 한다면이라는 조건(자바스크립트에서는 데이터가 존재하기만하면 true임)
		//    현 실습에서는 false 비교는 없으므로 == "true" 생략해도 되지만 정확하게 하기위해 명시
		
		// 현재 창 닫기
		window.close();	
		// -- c.f. 부모창 닫기는 window.opener.close();	
	} else {
		// 이전페이지로 돌아가기
		history.back();
		
	}
	
</script>