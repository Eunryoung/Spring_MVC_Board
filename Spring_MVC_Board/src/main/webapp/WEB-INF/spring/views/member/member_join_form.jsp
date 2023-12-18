<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		
		// 1.  버튼 클릭 시 새 창(check_id.html) 띄우기
		// 2. 아이디 입력란에서 커서가 빠져나갈 때 아이디 길이 체크 밒 ID 중복확인 수행하기 => blur
		document.joinForm.id.onblur = function() {
			let id = document.joinForm.id.value; // 입력받은 아이디값 저장
			
			// 입력된 ID 텍스트의 길이가 4 ~ 8글자 사이일 경우 
			// 우측 빈공간(span 태그 영역)에 "사용 가능" 초록색으로 표시
		    // 아니면, "4~8글자만 사용 가능합니다" 빨간색으로 표시
		    if(id.length >= 4 && id.length <= 8) {
		     	document.querySelector("#checkIdResult").innerText = "사용 가능";
		     	document.querySelector("#checkIdResult").style.color = "green";
		    } else {
		     	document.querySelector("#checkIdResult").innerText = "4~8글자만 사용 가능합니다";
		     	document.querySelector("#checkIdResult").style.color = "red";
		    }
		};
		
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
		
		// 4. 비밀번호확인 입력란에 키를 누를때마다 비밀번호와 같은지 체크하기
		document.joinForm.passwd2.onkeyup = function() {
			let passwd = document.joinForm.passwd.value;
			let passwd2 = document.joinForm.passwd2.value;
			
			// 비밀번호와 비밀번호확인 입력 내용이 같으면 "비밀번호 일치"(파란색) 표시,
   			// 아니면, "비밀번호 불일치"(빨간색) 표시
		    if(passwd == passwd2) { // 일치
		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 일치";
		     	document.querySelector("#checkPasswd2Result").style.color = "blue";
		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
		     	isSamePasswd = true;
		    } else { // 불일치
		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 불일치";
		     	document.querySelector("#checkPasswd2Result").style.color = "red";
		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
		     	isSamePasswd = false;
		    }
			
		};
		
		// 5. 주민번호 숫자 입력할때마다 길이 체크하기
		// => 주민번호 앞자리 입력란에 입력된 숫자가 6자리이면 뒷자리 입력란으로 커서 이동시키기
		// => 주민번호 뒷자리 입력란에 입력된 숫자가 7자리이면 뒷자리 입력란에서 커서 제거하기
		document.joinForm.jumin1.onkeyup = function() {
		    if(document.joinForm.jumin1.value.length == 6) {
		    	document.joinForm.jumin2.focus();
		    }
		};
		
		document.joinForm.jumin2.onkeyup = function() {
		    if(document.joinForm.jumin2.value.length == 7) {
		    	document.joinForm.jumin2.blur();
		    }
		};
		
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
		document.joinForm.onsubmit = function() {
			if(!isSamePasswd) { // 일치 여부 저장 변수 isSamePasswd 값 활용
				alert("패스워드 불일치!");
				document.joinForm.passwd2.focus();
				return false; // submit 동작 취소
// 			} else if(!document.joinForm.hobby[0].checked && !document.joinForm.hobby[1].checked && !document.joinForm.hobby[2].checked) {
// 				// 취미는 모든 체크박스 체크상태가 false 일 때 체크 요청 메세지 출력
// 				alert("취미 선택 필수!");
// 				return false; // submit 동작 취소
			}
			
			return true; // submit 동작 수행(생략 가능)
		};
		
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
					// 1) 우편번호(zonecode) 가져와서 우편번호 항목(post_code)에 출력
					document.joinForm.post_code.value = data.zonecode; 
					
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
		<h1>회원 가입</h1>
		<form action="MemberJoinPro" method="post" name="joinForm">
			<table border="1">
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" required></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" name="id" placeholder="8 ~ 16글자" required>
						<span id="checkIdResult"></span>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="passwd" placeholder="8 ~ 16글자" required>
						<span id="checkPasswdResult"></span>
					</td>
				</tr>
				<tr>
					<th>비밀번호확인</th>
					<td>
						<input type="password" name="passwd2" required>
						<span id="checkPasswd2Result"></span>
					</td>
				</tr>
				<tr>
					<th>주민번호</th>
					<td>
						<!-- 입력 문자 갯수 제한 시 maxLength 속성 지정 -->
						<input type="text" name="jumin1" size="8" maxlength="6" required> -
						<input type="text" name="jumin2" size="8" maxlength="7" required>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td>
						<input type="text" name="post_code" id="postCode" size="6" required>
						<input type="button" id="btnSearchAddress" value="주소검색">
						<br>
						<input type="text" name="address1" id="address1" size="25" placeholder="기본주소" required>
						<br>
						<input type="text" name="address2" id="address2" size="25" placeholder="상세주소" required>
					</td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td>
						<input type="text" name="email1" size="8" required> @
						<input type="text" name="email2" size="8" required>
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
						<select name="job" required>
							<option value="">항목을 선택하세요</option>
							<option value="개발자">개발자</option>
							<option value="DB엔지니어">DB엔지니어</option>
							<option value="서버엔지니어">서버엔지니어</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<input type="radio" name="gender" value="남" required>남
						<input type="radio" name="gender" value="여" required>여
					</td>
				</tr>
				<tr>
					<th>취미</th>
					<td>
						<input type="checkbox" name="hobby" value="여행">여행
						<input type="checkbox" name="hobby" value="독서">독서
						<input type="checkbox" name="hobby" value="게임">게임
						<input type="checkbox" id="checkAllHobby" value="전체선택">전체선택
					</td>
				</tr>
				<tr>
					<th>가입동기</th>
					<td>
						<textarea rows="5" cols="40" name="motivation" required></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="가입">
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











