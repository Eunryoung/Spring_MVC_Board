<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- JSTL 에서 split() 등의 함수 사용을 위해 functions 라이브러리 추가(${fn:xxx()} 형식으로 활용) --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<!-- 다음 주소검색 API 사용을 위한 라이브러리 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	window.onload = function() {
		let isSamePasswd = false; // 패스워드 일치 여부 저장할 변수
		
		// 3. 비밀번호 입력란에 키를 누를때마다 비밀번호 길이 체크하기 = keyup
		document.joinForm.passwd.onkeyup = function() {
			let passwd = document.joinForm.passwd.value;
			
			// 비밀번호 길이 체크를 통해 8 ~ 16글자 사이이면 "사용 가능한 패스워드"(파란색) 표시,
			// 아니면, "사용 불가능한 패스워드"(빨간색) 표시
		    if(passwd.length >= 8 && passwd.length <= 16) {
		     	document.querySelector("#checkPasswdResult").innerText = "사용 가능한 패스워드";
		     	document.querySelector("#checkPasswdResult").style.color = "blue";
		    } else {
		     	document.querySelector("#checkPasswdResult").innerText = "사용 불가능한 패스워드";
		     	document.querySelector("#checkPasswdResult").style.color = "red";
		    }
			
		};
		
		// 4. 비밀번호확인 입력란에 커서 벗어날 때 비밀번호와 같은지 체크하기
// 		document.joinForm.passwd2.onblur = function() {
// 			let passwd = document.joinForm.passwd.value;
// 			let passwd2 = document.joinForm.passwd2.value;
			
// 			// 비밀번호와 비밀번호확인 입력 내용이 같으면 "비밀번호 일치"(파란색) 표시,
//    			// 아니면, "비밀번호 불일치"(빨간색) 표시
// 		    if(passwd == passwd2) { // 일치
// 		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 일치";
// 		     	document.querySelector("#checkPasswd2Result").style.color = "blue";
// 		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
// 		     	isSamePasswd = true;
// 		    } else { // 불일치
// 		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 불일치";
// 		     	document.querySelector("#checkPasswd2Result").style.color = "red";
// 		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
// 		     	isSamePasswd = false;
// 		    }
			
// 		};
		
		// 6. 이메일 도메인 선택 셀렉트 박스 항목 변경 시 = change
		//    선택된 셀렉트 박스 값을 이메일 두번째 항목(@ 기호 뒤)에 표시하기
		document.joinForm.emailDomain.onchange = function() {
			document.joinForm.email2.value = document.joinForm.emailDomain.value;
			
			// 단, 직접입력 선택 시 표시된 도메인 삭제하기
		    // 또한, "직접입력" 항목 외의 도메인 선택 시 도메인 입력창을 잠금처리 및 회색으로 변경하고,
		    // "직접입력" 항목 선택 시 도메인 입력창에 커서 요청 및 잠금 해제
		    if(document.joinForm.emailDomain.value == "") { // 직접 입력 선택 시
		    	document.joinForm.email2.focus(); // 포커스 요청
		    	document.joinForm.email2.readOnly = false; // 입력창 잠금 해제(readonly 아님!)
		    	document.joinForm.email2.style.background = "";
		    } else { // 도메인 선택 시
		    	document.joinForm.email2.readOnly = true; // 입력창 잠금 해제
		    	document.joinForm.email2.style.background = "lightgray";
		    }
		};
		
		// 7. 취미의 "전체선택" 체크박스 체크 시 취미 항목 모두 체크, 
		//    "전체선택" 해제 시 취미 항목 모두 체크 해제하기
		document.querySelector("#checkAllHobby").onclick = function() {
			for(let i = 0; i < document.joinForm.hobby.length; i++) {
				document.joinForm.hobby[i].checked = document.querySelector("#checkAllHobby").checked;
			}
		};
		
		// 8. 가입(submit) 클릭 시 이벤트 처리를 통해
	    // 비밀번호 2개가 일치하는지 체크하고 모든 항목이 입력되었을 경우에만 submit 동작이 수행되도록 처리
// 		document.joinForm.onsubmit = function() {
// 			if(!isSamePasswd) { // 일치 여부 저장 변수 isSamePasswd 값 활용
// 				alert("패스워드 불일치!");
// 				document.joinForm.passwd2.focus();
// 				return false; // submit 동작 취소
// 			} else if(!document.joinForm.hobby[0].checked && !document.joinForm.hobby[1].checked && !document.joinForm.hobby[2].checked) {
// 				// 취미는 모든 체크박스 체크상태가 false 일 때 체크 요청 메세지 출력
// 				alert("취미 선택 필수!");
// 				return false; // submit 동작 취소
// 			}
// 			
// 			return true; // submit 동작 수행(생략 가능)
// 		};
		
		// =====================================================================
		// 주소 검색 API 활용 기능 추가
		// "t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
		document.querySelector("#btnSearchAddress").onclick = function() {
			new daum.Postcode({
				// 주소검색 창에서 주소 검색 후 검색된 주소를 클릭하면
				// oncomplete: 뒤의 익명함수가 실행(호출)됨 => callback(콜백) 함수라고 함
		        oncomplete: function(data) {
		        	// 클릭(선택)된 주소에 대한 정보(객체)가 익명함수 파라미터 data 에 전달됨
					// => data.xxx 형식으로 각 주소 정보에 접근
					// 1) 우편번호(zonecode) 가져와서 우편번호 항목(postCode)에 출력
					document.joinForm.postCode.value = data.zonecode; 
					
					// 2) 기본주소(address) 가져와서 기본주소 항목(address1)에 출력
// 					document.joinForm.address1.value = data.address;
					let address = data.address;
					
					// 만약, 건물명(buildingName)이 존재(널스트링이 아님)할 경우
					// 기본주소 뒤에 건물명을 결합
					if(data.buildingName != "") {
						address += " (" + data.buildingName + ")";
					}
					
					document.joinForm.address1.value = address;
					
					// 3) 상세주소 항목(address2)에 포커스(커서) 요청
					document.joinForm.address2.focus();
		        }
		    }).open();
		};
		
	}; // window.onload 이벤트 끝
</script>
</head>
<body>
	<header>
		<!-- inc/top.jsp 페이지 삽입 -->
		<!-- JSP 파일 삽입 대상은 현재 파일을 기준으로 상대주소 지정 -->
		<!-- webapp 디렉토리를 가리키려면 최상위(루트) 경로 활용 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<h1>회원 정보 수정</h1>
		<form action="MemberModifyPro" method="post" name="joinForm">
			<table border="1">
				<tr>
					<th>이름</th>
					<%-- 회원 상세정보 페이지와 달리 수정 폼이므로 value 속성으로 값 출력 --%>
					<td><input type="text" name="name" value="${member.name }" required></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td>
						<%-- 아이디 편집 불가(readonly 필수! disabled 는 파라미터 전송에서 제외됨) --%>
<%-- 						<input type="text" name="id" value="${member.id }" readonly>(변경불가) --%>
						<%-- 만약, 아이디 파라미터 전송도 불필요할 경우 데이터만 표시 --%>
						${member.id }(변경불가)
					</td>
				</tr>
				<tr>
					<th>기존 비밀번호</th>
					<td>
						<input type="password" name="passwd" placeholder="8 ~ 16글자" required>
						<span id="checkPasswdResult"></span>
					</td>
				</tr>
				<tr>
					<th>새 비밀번호</th>
					<td>
						<input type="password" name="newPasswd" placeholder="8 ~ 16글자(변경시에만 입력)">
						<span id="checkNewPasswdResult"></span>
					</td>
				</tr>
				<tr>
					<th>새 비밀번호확인</th>
					<td>
						<input type="password" name="newPasswd2" placeholder="(변경시에만 입력)">
						<span id="checkNewPasswd2Result"></span>
					</td>
				</tr>
				<tr>
					<th>주민번호</th>
					<td>${member.jumin} (변경불가)</td>
				</tr>
				<tr>
					<th>주소</th>
					<td>
						<%--
						==================================================================
						[ 자바 코드를 통해 전달받은 주소에 대한 문자열 편집 ]
						JSTL - functions 라이브러리의 split() 함수 활용하여 주소 분리
						1. JSTL 의 functions 라이브러리 등록 필요(prefix : fn)
						2. split() 함수를 사용하여 "/" 기준으로 문자열 분리 후 변수에 저장
						   => ${fn:split(원본문자열, '구분자')} 로 분리 후
						      <c:set> 태그 활용하여 분리된 데이터가 저장된 배열 변수에 저장
						   => 주의! 원본 문자열을 EL 을 통해 전달 시 ${} 중복 사용 X
						   => String[] arrAddress = address.split("/"); 와 동일한 작업 수행
						3. 분리된 데이터가 저장된 배열을 활용하여 각 데이터 출력
						   => EL 에서의 배열 사용은 일반 배열과 동일하게 접근
						   => ${배열명[인덱스]}
						==================================================================
						--%>
						<input type="text" name="post_code" id="postCode" value="${member.post_code}" size="6" required>
						<input type="button" id="btnSearchAddress" value="주소검색">
						<br>
						<input type="text" name="address1" id="address1" value="${member.address1}" size="25" placeholder="기본주소" required>
						<br>
						<input type="text" name="address2" id="address2" value="${member.address2}" size="25" placeholder="상세주소" required>
					</td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td>
						<%-- 이메일 주소 분리("@" 기준)하여 표시 --%>
						<c:set var="arrEmail" value="${fn:split(member.email, '@')}" />
						<input type="text" name="email1" value="${arrEmail[0]}" size="8" required> @
						<input type="text" name="email2" value="${arrEmail[1]}" size="8" required>
						<select name="emailDomain">
							<option value="">직접입력</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="nate.com">nate.com</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>직업</th>
					<td>
						<select name="job">
							<option value="">항목을 선택하세요</option>
							<%-- 직업과 일치하는 셀렉트박스 항목 선택(selected) --%>
							<option value="개발자" <c:if test="${member.job eq '개발자'}">selected</c:if>>개발자</option>
							<option value="DB엔지니어" <c:if test="${member.job eq 'DB엔지니어'}">selected</c:if>>DB엔지니어</option>
							<option value="서버엔지니어" <c:if test="${member.job eq '서버엔지니어'}">selected</c:if>>서버엔지니어</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<%-- 성별과 일치하는 라디오버튼 항목 선택(checked) --%>
						<input type="radio" name="gender" value="남" <c:if test="${member.gender eq '남'}">checked</c:if> required>남
						<input type="radio" name="gender" value="여" <c:if test="${member.gender eq '여'}">checked</c:if> required>여
					</td>
				</tr>
				<tr>
					<th>취미</th>
					<td>
						<%-- 취미 항목은 분리없이 해당 항목이 포함되어 있는지 여부로 확인 가능 --%>
						<%-- ${fn:contains()} 메서드 활용 가능 --%>
						<input type="checkbox" name="hobby" value="여행" <c:if test="${fn:contains(member.hobby, '여행')}">checked</c:if>>여행
						<input type="checkbox" name="hobby" value="독서" <c:if test="${fn:contains(member.hobby, '독서')}">checked</c:if>>독서
						<input type="checkbox" name="hobby" value="게임" <c:if test="${fn:contains(member.hobby, '게임')}">checked</c:if>>게임
						<input type="checkbox" id="checkAllHobby" value="전체선택">전체선택
					</td>
				</tr>
				<tr>
					<th>가입동기</th>
					<td>
						<textarea rows="5" cols="40" name="motivation" required>${member.motivation }</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="정보수정">
						<input type="reset" value="초기화">
						<input type="button" value="돌아가기">
					</td>
				</tr>
			</table>
		</form>
	</article>
	<footer>
	
	</footer>
</body>
</html>











